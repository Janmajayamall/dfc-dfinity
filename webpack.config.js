const path = require("path");
const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin");

let localCanisters, prodCanisters, canisters, network;

function initCanisterIds() {
	try {
		localCanisters = require(path.resolve(
			".dfx",
			"local",
			"canister_ids.json"
		));
	} catch (error) {
		console.log("No local canister_ids.json found. Continuing production");
	}
	try {
		prodCanisters = require(path.resolve("canister_ids.json"));
	} catch (error) {
		console.log(
			"No production canister_ids.json found. Continuing with local"
		);
	}

	network =
		process.env.DFX_NETWORK ||
		(process.env.NODE_ENV === "production" ? "ic" : "local");

	canisters = network === "local" ? localCanisters : prodCanisters;
	for (const canister in canisters) {
		process.env[canister.toUpperCase() + "_CANISTER_ID"] =
			canisters[canister][network];
	}
}
initCanisterIds();
console.log(canisters["DfcData"][network]);

const isDevelopment = process.env.NODE_ENV !== "production";
const asset_entry = path.join("src", "dfc_assets", "src", "index.html");

/**
 * Generate a webpack configuration for a canister.
 */
module.exports = {
	target: "web",
	mode: isDevelopment ? "development" : "production",
	entry: {
		// The frontend.entrypoint points to the HTML file for this build, so we need
		// to replace the extension to `.js`.
		index: path.join(__dirname, asset_entry).replace(/\.html$/, ".jsx"),
	},
	devtool: isDevelopment ? "source-map" : false,
	optimization: {
		minimize: !isDevelopment,
		minimizer: [new TerserPlugin()],
	},
	resolve: {
		extensions: [".js", ".ts", ".jsx", ".tsx"],
		fallback: {
			assert: require.resolve("assert/"),
			buffer: require.resolve("buffer/"),
			events: require.resolve("events/"),
			stream: require.resolve("stream-browserify/"),
			util: require.resolve("util/"),
		},
	},
	output: {
		filename: "index.js",
		path: path.join(__dirname, "dist", "dfc_assets"),
	},

	// Depending in the language or framework you are using for
	// front-end development, add module loaders to the default
	// webpack configuration. For example, if you are using React
	// modules and CSS as described in the "Adding a stylesheet"
	// tutorial, uncomment the following lines:
	module: {
		rules: [
			{ test: /\.(ts|tsx|jsx)$/, loader: "ts-loader" },
			{ test: /\.css$/, use: ["style-loader", "css-loader"] },
		],
	},
	plugins: [
		new HtmlWebpackPlugin({
			template: path.join(__dirname, asset_entry),
			cache: false,
		}),
		new CopyPlugin({
			patterns: [
				{
					from: path.join(__dirname, "src", "dfc_assets", "assets"),
					to: path.join(__dirname, "dist", "dfc_assets"),
				},
			],
		}),
		new webpack.EnvironmentPlugin({
			NODE_ENV: "development",
			DFCDATA_CANISTER_ID: canisters["DfcData"][network],
			DFCUSERS_CANISTER_ID: canisters["DfcUsers"][network],
			DFCUSERSDATA_CANISTER_ID: canisters["DfcUsersData"][network],
			DFCREPUTATIONSCORER_CANISTER_ID:
				canisters["DfcReputationScorer"][network],
			DFCFEED_CANISTER_ID: canisters["DfcFeed"][network],
			DFCTOKEN_CANISTER_ID: canisters["DfcToken"][network],
			II_URL: false
				? "http://localhost:8000?canisterId=rwlgt-iiaaa-aaaaa-aaaaa-cai#authorize"
				: "https://identity.ic0.app/#authorize",
		}),
		new webpack.ProvidePlugin({
			Buffer: [require.resolve("buffer/"), "Buffer"],
			process: require.resolve("process/browser"),
		}),
	],
	devServer: {
		proxy: {
			"/api": {
				target: "http://localhost:8000",
				changeOrigin: true,
				pathRewrite: {
					"^/api": "/api",
				},
			},
		},
		hot: true,
		contentBase: path.resolve(__dirname, "./src/avatar_assets"),
		watchContentBase: true,
		port: 3000,
		historyApiFallback: true,
	},
};

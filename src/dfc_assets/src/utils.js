export const dummyFeed = [
	{
		comments: [
			{
				id: "0",
				contentId: "0",
				createdAt: 1627592149940225000n,
				text: "this is the comment",
				user: { username: "newUser1" },
			},
		],
		content: {
			contentIdentification: {
				postId: "1410462056495542277",
				site: { twitter: null },
			},
			createdAt: 1627592144734283000n,
			id: "1",
			user: { id: "0", username: "newUser" },
			burntTokens: 150,
		},
		contentId: "0",
		ratings2d: [
			[
				{
					id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
					commentId: "0",
					ratingValue: true,
					user: { id: 1, username: "dawda" },
				},
			],
		],
	},
	{
		comments: [
			{
				id: "0",
				contentId: "0",
				createdAt: 1627592149940225000n,
				text: "this is the comment",
				user: { username: "newUser2" },
			},
		],
		content: {
			contentIdentification: {
				postId: "1410462056495542277",
				site: { twitter: null },
			},
			createdAt: 1627592144734283000n,
			id: "1",
			user: { id: "1", username: "newUser3" },
			burntTokens: 200,
		},
		contentId: "1",
		ratings2d: [
			[
				{
					id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
					commentId: "0",
					ratingValue: false,
					user: { id: 2, username: "dawda" },
				},
			],
		],
	},
];

export const colorScheme = {
	primary: "#14171A",
	secondary: "#222222",
	darkGrey: "#657786",
	textPrimary: "#ffffff",
	red: "#FF5A5F",
};

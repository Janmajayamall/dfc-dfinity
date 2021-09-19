import { useEffect, useState } from "react";
import { AuthClient } from "@dfinity/auth-client";

export function useAuth() {
	const [authClient, setAuthClient] = useState();
	const [isAuthenticated, setIsAuthenticated] = useState();

	useEffect(async () => {
		AuthClient.create().then(async (client) => {
			const isAuthenticated = await client.isAuthenticated();
			setAuthClient(client);
			setIsAuthenticated(isAuthenticated);
		});
	}, []);

	function login() {
		authClient?.login({
			identityProvider: process.env.II_URL,
			onSuccess: () => {
				setIsAuthenticated(true);
			},
		});
	}

	function logout() {
		setIsAuthenticated(false);
	}

	return {
		authClient,
		isAuthenticated,
		login,
		logout,
	};
}

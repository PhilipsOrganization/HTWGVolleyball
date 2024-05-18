<script>
	import { Button, Container, Head, Hr, Html, Section, Text } from 'svelte-email';

	/**
	 * @type {import("$lib/db/schema").Account}
	 */
	export let user;

	/**
	 * @type {string}
	 */
	export let token;

	const fontFamily = '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif';

	const main = {
		backgroundColor: '#fff'
	};

	const container = {
		margin: '0 auto',
		padding: '20px 0 48px',
		width: '580px'
	};

	const button = {
		fontFamily,
		padding: '24px',
		backgroundColor: '#9cc1cf',
		borderRadius: '3px',
		color: '#000',
		fontSize: '18px',
		textDecoration: 'none',
		textAlign: 'center',
		display: 'block',
		width: '80%'
	};

	const paragraph = {
		fontFamily,
		fontSize: '18px',
		lineHeight: '1.4',
		color: '#484848'
	};

	const heading = {
		fontFamily,
		fontSize: '32px',
		lineHeight: '1.3',
		fontWeight: '700',
		color: '#484848'
	};
</script>

<Html lang="en">
	<Head />
	<Section style={main}>
		<Container style={container}>
			<Text style={heading}>Hello, {user.username}!</Text>
			<Hr />
			<Button style={button} href="https://volleyball.oesterlin.dev/new-password?token={token}&user={user.id}">Reset Password</Button>
		</Container>
	</Section>
	<Text>If you did not create an account, no further action is required.</Text>
</Html>

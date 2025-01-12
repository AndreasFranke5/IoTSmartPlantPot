const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

exports.createUser = onRequest(async (request, response) => {
  try {
    const { userId, email, name } = request.body;

    if (!userId || !email || !name) {
      response.status(400).send('Invalid input');
      return;
    }

    const userRef = admin.database().ref(`users/${userId}`);
    const result = await userRef.transaction((user) => {
      if (!user) {
        return {
          id: userId,
          name: name,
          email: email,
          // image: picture,
        };
      }
    });
    // const userData = result.snapshot.val();
    // response.status(200).json({
    //   email: userData.email,
    //   name: userData.name,
    //   image: userData.image,
    // });

    response.status(201).send('User created successfully');
  } catch (error) {
    console.error('Error creating user:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.loginWithGoogle = onRequest(async (request, response) => {
  try {
    const { idToken } = request.body;

    if (!idToken) {
      response.status(400).send('Invalid input');
      return;
    }

    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { uid, email, name, picture } = decodedToken;

    // Check if the user already exists
    const authUser = await admin.auth().getUserByEmail(email);
    if (!authUser) {
      await admin.auth().createUser({
        uid: uid,
        email: email,
        displayName: name,
      });
    }

    const userRef = admin.database().ref(`users/${authUser.uid}`);
    const result = await userRef.transaction((user) => {
      if (!user) {
        return {
          id: uid,
          name: name,
          email: email,
          image: picture,
        };
      }
    });
    const userData = result.snapshot.val();
    response.status(200).json({
      email: userData.email,
      name: userData.name,
      image: userData.image,
      idToken,
    });
  } catch (error) {
    console.error('Error creating user:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.login = onRequest(async (request, response) => {
  try {
    const { idToken } = request.body;

    if (!idToken) {
      response.status(400).send('Invalid input');
      return;
    }

    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userRef = admin.database().ref(`users/${existingUser.id}`);
    await userRef.once('value', (snapshot) => {
      const user = snapshot.val();
      response.status(200).json({ ...user, idToken });
    });
  } catch (error) {
    console.error('Error creating user:', error);
    response.status(500).send('Internal Server Error');
  }
});

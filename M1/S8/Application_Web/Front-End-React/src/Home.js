import { useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react';

function Home() {
    const [isLoggedIn, setIsLoggedIn] = useState(true);
    const [userType, setUserType] = useState("");
    const [username, setUsername] = useState("");
    const navigate = useNavigate(); // Use the navigate hook to navigate to another route

    useEffect(() => {
        // Check if user is logged in
        const checkLoginStatus = async () => {
            try {
                const response = await fetch('/API/Auth');
                if (response.ok) {
                    const userData = await response.json();
                    setUserType(userData.userType);
                    setUsername(userData.username);
                    setIsLoggedIn(true);
                } else {
                    navigate('/login'); // Redirect to login if not logged in
                }
            } catch (error) {
                console.error('Error checking session:', error);
            }
        };
        checkLoginStatus();
    }, [navigate]);

    // Redirect to appropriate page based on userType
    useEffect(() => {
        if (isLoggedIn) {
            if (userType === "PROFESSOR") {
                navigate('/accueilprof');
            } else if (userType === "STUDENT") {
                navigate('/accueileleve');
            }
        }
    }, [isLoggedIn, navigate, userType]);

    return (
        <div>
            {isLoggedIn && (
                <>
                    <p>Welcome {userType} {username}</p>
                </>
            )}
        </div>
    );
}

export default Home;
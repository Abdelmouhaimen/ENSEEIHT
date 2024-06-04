import { FaUser, FaEye, FaEyeSlash } from "react-icons/fa";
import './Login.css';
import { useRef, useState, useEffect } from "react";
import { useNavigate} from 'react-router-dom';

function Login () {


    const [showPassword, setShowPassword] = useState(false);
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const passwordInputRef = useRef(null);
    const navigate = useNavigate(); // Use the navigate hook to navigate to another route

    const handleTogglePasswordVisibility = () => {
        setShowPassword(prevState => !prevState);
        const passwordInput = passwordInputRef.current;
        if (passwordInput) {
            passwordInput.type = showPassword ? "text" : "password";
        }
    };

    useEffect(() => {
        // Check if user is logged in
        const logout = async () => {
            try {
                const response = await fetch('/API/logout');
            } catch (error) {
                console.error('Error with the server:', error);
            }
        };
        logout();
    }, [navigate]);

    const handleSubmit = async (e) => {
        e.preventDefault();
    
        // Construct the authentication payload
        const credentials = {
            username,
            password
        };
    
        try {
            const response = await fetch('/API/Auth', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(credentials)
            });
    
            if (response.ok) {
                navigate('/'); // Navigate to home page
            } else {
                // Authentication failed, show error message
                console.error('Authentication failed');
            }
        } catch (error) {
            console.error('Error during authentication:', error);
        }
    };

    return (
        <div className="wrapper"> 
            <form onSubmit={handleSubmit}>
                <h1>Login</h1>
                <div className="input-box">
                    <input
                        type="text"
                        placeholder="Username"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                    />
                    <FaUser className="icon" />
                </div>
                <div className="input-box">
                    <input
                        ref={passwordInputRef}
                        type={showPassword ? "text" : "password"}
                        placeholder="Password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                    {showPassword ? (
                        <FaEyeSlash className="icon" onClick={handleTogglePasswordVisibility} />
                    ) : (
                        <FaEye className="icon" onClick={handleTogglePasswordVisibility} />
                    )}
                </div>
                <button type="submit">Connexion</button>
            </form>
        </div>
    );
}

export default Login;


import { PiStudentBold } from "react-icons/pi";
import { Link } from "react-router-dom";
import "./Navbar.css";
import Dropdown from "./Dropdown";
import { useState, useEffect } from "react";
import { useNavigate } from 'react-router-dom';


function Navbar() {
    
    const [isLoggedIn, setIsLoggedIn] = useState(false);
    const [dropdown, setDropdown] = useState(false);
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
                    setUsername(userData.username);
                    setUserType(userData.userType);
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


    const navItems = [
        {
            id: 1,
            title: username,
            path: "/",
            cName: "nav-item",
        }
    ];

    if (!isLoggedIn) {
        return null;
    }

    return (
        <div className="nav-container">
            <nav className="navbar">
                <Link to="/" className="navbar-logo">
                    TESTN7
                    <PiStudentBold />
                </Link>
                <ul className="nav-items">
                    {navItems.map(item => {
                        return (
                            <li
                                key={item.id}
                                className={item.cName}
                                onClick={() => { setDropdown(!dropdown) }}>
                                <Link to={item.path}>
                                    {item.title}
                                </Link>
                                {dropdown && <Dropdown />}
                            </li>
                        )
                    })}
                </ul>
            </nav>
        </div>
    )
}

export default Navbar;

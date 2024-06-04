import { Link } from "react-router-dom";
import "./Dropdown.css"
import { useState } from "react";

function Dropdown (){
    const serviceDropdown = [
        {
            id:1,
            title :"Deconnexion",
            path:"/login",
            cName : "submenu-item",

        },
        {
            id:2,
            title :"Profil",
            path:"/",
            cName : "submenu-item",

        },
    ];

    const [dropdown , setDropdown] = useState(false);

    return (
        
        <ul className={dropdown ? "services-submenu clicked" : "services-submenu"} onClick={()=> setDropdown(!dropdown)} >
            {serviceDropdown.map( item => {  return(
                <li key={item.id} className={item.cName}>
                    <Link 
                    onClick={() => setDropdown(false)}
                    to={item.path}>
                        {item.title}
                    </Link>
                </li>)
            }
            )}
        </ul>
        
        
    )

}
export default Dropdown
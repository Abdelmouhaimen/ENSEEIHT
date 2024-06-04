import { useParams } from "react-router-dom";
import "./Choixprof.css";
import { BrowserRouter as Router, Route, Link, Switch } from 'react-router-dom';


function  Choixprof() {
    const {id , title} = useParams();
    return (
      <>
        <div className="accueil-prof">
          <div className="accueil-prof-container">
            
            <Link to={`/Creationtest/${id}`} className="link-button">
              Création de Test
            </Link>
            <Link to={`/coursprof/${id}/${title}`} className="link-button">
              voir les resultats des tests
            </Link>
          </div>
        </div>
      </>
    );
  }
  
  export default Choixprof;
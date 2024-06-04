
import { useState, useEffect } from "react";
import { useParams } from 'react-router-dom';
import './Quizprof.css';
import Navbar from './components/Navbar';


function Quizprof(){
    const [etudiant, setEtudiant] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const { id } = useParams();

    useEffect(() => {
        fetch(`/API/results?id=${id}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                setEtudiant(data);
                setLoading(false);
            })
            .catch(error => {
                setError(error);
                setLoading(false);
            });
    }, []); 
        


    if (loading) {
        return <div>Loading...</div>;
    }


    return (
        <>
        <Navbar/>
        <div>
            <h2> Resultat {}</h2>
            <table>
                <thead>
                    <tr>
                        <th>username</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    {etudiant.map(etudiant => (
                        <tr key={etudiant.id}>
                            <td>{etudiant.student}</td>
                            <td>{etudiant.score}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
        </>
    );
}

export default Quizprof;

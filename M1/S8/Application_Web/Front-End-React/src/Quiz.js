import { useRef, useState, useEffect } from "react";
import { useNavigate, useParams } from 'react-router-dom';
import './Quiz.css';

function Timer(props) {
    const [counter, setCounter] = useState(props.duration);
    const intervalRef = useRef(null);

    useEffect(() => {
        intervalRef.current = setInterval(() => {
            setCounter((prev) => prev - 1);
        }, 1000);

        return () => { clearInterval(intervalRef.current); };
    }, []);

    useEffect(() => {
        if (counter === 0) {
            clearInterval(intervalRef.current);
            props.onTimeOut();
        }
    }, [counter, props]);

    const formatTime = () => {
        const hours = Math.floor(counter / 3600);
        const minutes = Math.floor((counter % 3600) / 60);
        const seconds = counter % 60;

        const formattedHours = hours < 10 ? '0' + hours : hours;
        const formattedMinutes = minutes < 10 ? '0' + minutes : minutes;
        const formattedSeconds = seconds < 10 ? '0' + seconds : seconds;

        return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
    };

    return (
        <div className="Timer-container">
            {formatTime()}
        </div>
    );
}

function Quiz() {
    const [QuizData, setQuizData] = useState(null);
    const { id } = useParams();
    const navigate = useNavigate();

    const [currentQuestion, setCurrentQuestion] = useState(0);
    const [showResults, setShowResults] = useState(false);
    const [response, setResponse] = useState(null);
    const [responses, setResponses] = useState([]);

    useEffect(() => {
        const fetchQuizData = async () => {
            try {
                const response = await fetch(`/API/quiz?id=${id}`);
                if (response.ok) {
                    const data = await response.json();
                    setQuizData(data);
                } else {
                    console.error('Failed to fetch quiz data');
                }
            } catch (error) {
                console.error('Error fetching quiz data:', error);
            }
        };

        fetchQuizData();
    }, [id]);

    if (QuizData === null) {
        return <div>Loading...</div>;
    }

    const { duration, questions } = QuizData;
    const currentQuestionData = questions[currentQuestion];
    const { id_question, question, choices = [], type } = currentQuestionData || {};

    const next = () => {
        setResponses((prev) => [...prev, { question_id: id_question, answer: response }]);
        setResponse(null);
        if (currentQuestion === questions.length - 1) {
            setShowResults(true);
        } else {
            setCurrentQuestion((prev) => prev + 1);
        }
    };

    const handleTimeOut = () => {
        if (response !== null) {
            setResponses((prev) => [...prev, { question_id: id_question, answer: response }]);
        }
        setShowResults(true);
    };

    const renderQuestion = () => {
        return (
            <ul>
                {Array.isArray(choices) && choices.map((choice, index) => (
                    <div className="choice" key={index}>
                        <li>
                            <label>
                                <input
                                    type="radio"
                                    name="options"
                                    value={choice}
                                    onChange={(e) => { setResponse(e.target.value); }}
                                />
                                {choice}
                            </label>
                        </li>
                    </div>
                ))}
            </ul>
        );
    };

    const sendResults = () => {
        const answers = {
            quiz_id: id,
            answers: responses
        };

        fetch('/API/submitAnswers', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(answers)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            console.log('Success:', data);
            navigate("AccueilEleve");
        })
        .catch(error => {
            console.error('Error:', error);
        });
    };

    return (
        <div className="container">
            {!showResults ?
                <>
                    <Timer duration={duration} onTimeOut={handleTimeOut} />
                    <h1> Image </h1>
                    <hr />
                    <h2> {question}</h2>
                    {renderQuestion()}
                    <button onClick={next}> Next </button>
                    <div className="index"> {currentQuestion + 1} of {questions.length}</div>
                </>
                :
                <div>
                    <p> Le test est maintenant terminé. Cliquez sur le bouton pour envoyer vos réponses pour correction.</p>
                    <button onClick={sendResults}> envoyer les reponses</button>
                </div>
            }
        </div>
    );
}

export default Quiz;
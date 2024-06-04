package entities;

import javax.persistence.*;

import java.util.Collection;
import java.util.List;

@Entity
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne
    private Quiz quiz;

    private String question;

    private String correctAnswer;

    private String type;

    @ElementCollection(fetch = FetchType.EAGER)
    private List<String> choices;

    @OneToMany(mappedBy = "question")
    private Collection<Answer> answers;

    // Getters

    public long getId() {
        return id;
    }

    public Quiz getQuiz() {
        return quiz;
    }

    public String getQuestion() {
        return question;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public String getType() {
        return type;
    }

    public List<String> getChoices() {
        return choices;
    }

    public Collection<Answer> getAnswers() {
        return answers;
    }

    // Setters

    public void setId(long id) {
        this.id = id;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setChoices(List<String> choices) {
        this.choices = choices;
    }

    public void setAnswers(Collection<Answer> answers) {
        this.answers = answers;
    }
}

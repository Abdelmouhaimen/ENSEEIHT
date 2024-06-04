package entities;

import java.util.Collection;

import javax.persistence.*;


@Entity
public class Response {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

	@ManyToOne
    private Quiz quiz;

    @OneToMany(mappedBy = "response")
    private Collection<Answer> answers;

    @ManyToOne
    private Student student;
    
    private int score; // New attribute for score

    // Getters
    public Long getId() {
        return id;
    }

    public Quiz getQuiz() {
        return quiz;
    }
    public int getScore() {
		return score;
		
	}

    public Collection<Answer> getAnswers() {
        return answers;
    }

    public Student getStudent() {
        return student;
    }

    // Setters
    public void setId(Long id) {
        this.id = id;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public void setAnswers(Collection<Answer> answers) {
        this.answers = answers;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

	public void setScore(int score) {
		this.score=score;
		
	}

}
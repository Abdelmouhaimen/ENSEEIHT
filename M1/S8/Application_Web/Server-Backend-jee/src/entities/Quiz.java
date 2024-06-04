package entities;

import javax.persistence.*;
import java.util.Collection;

@Entity
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titre;

    private float duration;

    @OneToMany(mappedBy = "quiz")
    private Collection<Question> questions;

    @OneToMany(mappedBy = "quiz")
    private Collection<Response> responses;
    
    @ManyToOne
    private Course course;
    
    // Getters

    public Long getId() {
        return id;
    }

    public String getTitre() {
        return titre;
    }

    public float getDuration() {
        return duration;
    }

    public Collection<Question> getQuestions() {
        return questions;
    }

    public Collection<Response> getResponses() {
        return responses;
    }

    public Course getGroup() {
        return course;
    }

    // Setters

    public void setId(Long id) {
        this.id = id;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public void setDuration(float duration) {
        this.duration = duration;
    }

    public void setQuestions(Collection<Question> questions) {
        this.questions = questions;
    }

    public void setResponses(Collection<Response> responses) {
        this.responses = responses;
    }

    public void setGroup(Course course) {
        this.course = course;
    }

    
}


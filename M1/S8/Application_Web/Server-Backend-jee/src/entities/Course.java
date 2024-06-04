package entities;

import java.util.Collection;

import javax.persistence.*;


@Entity
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToMany
    private Collection<Student> students;

    @OneToMany(mappedBy = "course")
    private Collection<Quiz> quizzes;

    private String title;

    // Getters
    public Long getId() {
        return id;
    }

    public Collection<Student> getStudents() {
        return students;
    }

    public Collection<Quiz> getQuizzes() {
        return quizzes;
    }

    public String getTitle() {
        return title;
    }

    // Setters
    public void setId(Long id) {
        this.id = id;
    }

    public void setStudents(Collection<Student> students) {
        this.students = students;
    }

    public void setQuizzes(Collection<Quiz> quizzes) {
        this.quizzes = quizzes;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}

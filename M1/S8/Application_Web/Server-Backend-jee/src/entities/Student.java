package entities;



import java.util.Collection;

import javax.persistence.*;

@Entity
public class Student extends User {
	@ManyToMany(mappedBy = "students", fetch = FetchType.EAGER)
    private Collection<Course> courses;

    @OneToMany(mappedBy = "student")
    private Collection<Response> responses;

    // Getters and Setters
    public Collection<Course> getGroups() {
        return courses;
    }

    public void setGroups(Collection<Course> courses) {
        this.courses = courses;
    }

    public Collection<Response> getResponses() {
        return responses;
    }

    public void setResponse(Collection<Response> responses) {
        this.responses = responses;
    }
}
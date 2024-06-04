package entities;



import javax.persistence.*;


@Entity
public class Answer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
	@ManyToOne
    private Response response;

    @ManyToOne
    private Question question;
    
    private String answer;

    // Getters
    public Long getId() {
        return id;
    }

    public Response getResponse() {
        return response;
    }

    public Question getQuestion() {
        return question;
    }

    public String getAnswer() {
        return answer;
    }

    // Setters

    public void setId(Long id) {
        this.id = id;
    }

    public void setResponse(Response response) {
        this.response = response;
    }

    public void setQuestion(Question question) {
        this.question = question;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    


}

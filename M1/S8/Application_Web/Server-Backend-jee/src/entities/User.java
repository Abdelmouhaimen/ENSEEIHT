package entities;
import javax.persistence.*;

@Entity
public class User {

    @Id
    private String username;

    @Column
    private String password;

    @Column
    private String type;

    // Constructors, getters, and setters

    public User() {
    }


	public String getPassword() {
		return password;
	}

	public String getUsername() {
		return username;
	}
	
	public String getType() {
		return type;
	}

	public void setPassword(String password) {
	    this.password = password;
	}

	public void setUsername(String username) {
	    this.username = username;
	}

	public void setType(String type) {
	    this.type = type;
	}

}

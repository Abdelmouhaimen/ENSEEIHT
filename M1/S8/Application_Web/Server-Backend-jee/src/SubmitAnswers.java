import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.ejb.EJB;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonValue;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.AdministrationLocal;
import com.fasterxml.jackson.databind.ObjectMapper;

import entities.Answer;

@WebServlet("/submitAnswers")
public class SubmitAnswers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private AdministrationLocal administration;

    public SubmitAnswers() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Vérifier si une session existe et si le nom d'utilisateur peut être trouvé dans la session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Unauthorized"));
            return;
        }

        // Lire le corps de la requête HTTP pour obtenir les réponses soumises
        StringBuilder requestBody = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                requestBody.append(line);
            }
        }

        // Analyser le corps JSON pour obtenir les réponses soumises
        JsonObject jsonBody = Json.createReader(new StringReader(requestBody.toString())).readObject();

        // Récupérer les paramètres du corps JSON
        Long quizId = Long.parseLong(jsonBody.getString("quiz_id"));
        String username = (String) session.getAttribute("username");
        JsonArray answersArray = jsonBody.getJsonArray("answers");

        // Valider les paramètres
        if (quizId == null || username == null || answersArray == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Missing parameters"));
            return;
        }

        try {
            // Convertir les réponses soumises en objets Answer
            List<Answer> answers = new ArrayList<>();
            for (JsonValue jsonValue : answersArray) {
                JsonObject answerObject = (JsonObject) jsonValue;
                String answerText = answerObject.getString("answer");
                Long questionId = (long)(answerObject.getInt("question_id"));
                Answer answer = administration.createAnswer(answerText, questionId);
                answers.add(answer);  
            }

            // Soumettre les réponses à votre façade Administration pour enregistrement
            administration.createResponse(quizId, username, answers);

            // Envoyer une réponse de succès
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("message", "Responses submitted successfully"));
        } catch (NumberFormatException e) {
            // Gérer un format de nombre invalide
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Invalid number format"));
        } catch (Exception e) {
            // Gérer toute autre exception
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Internal Server Error"));
            e.printStackTrace();
        }
    }
}
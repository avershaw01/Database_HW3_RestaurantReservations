import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class CustomerQueryTest {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/restaurant_db";
        String username = "root";
        String password = "root";

        try (Connection connection =
                     DriverManager.getConnection(url, username, password)) {
            //connection.createStatement()
            // UNFINISHED



        } catch (SQLException e) {

            System.out.println("Database connection failed!");
            e.printStackTrace();

        }
    }
}

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnectionTest {

    public static void main(String[] args) {

        // Database connection information
        String url = "jdbc:mysql://localhost:3306/restaurant_db";
        String username = "root";
        String password = "root";

        // Attempt to connect to MySQL
        try (Connection connection =
                     DriverManager.getConnection(url, username, password)) {

            System.out.println("Successfully connected to MySQL!");
            System.out.println("Database: " +
                    connection.getCatalog());

        } catch (SQLException e) {

            System.out.println("Database connection failed!");
            e.printStackTrace();

        }
    }
}
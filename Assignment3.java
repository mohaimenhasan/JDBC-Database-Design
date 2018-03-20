import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class Assignment3 extends JDBCSubmission {

    public Assignment3() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
	    //write your code here.
        try{
             connection = DriverManager.getconnection(url, username, password);
        }
        catch (Exception e){

        }
       
        return true;
    }

    @Override
    public boolean disconnectDB() {
	    //write your code here.
        try{
            connection.close();
        }
        catch (Exception e){

        }
        return true;
    }

    @Override
    public ElectionResult presidentSequence(String countryName) {
            //Write your code here.
            
            return null;
	}

    @Override
    public List<Integer> findSimilarParties(Integer partyId, Float threshold) {
	//Write your code here.
        return null;
    }

    public static void main(String[] args) throws Exception {
   	    //Write code here. 
	    System.out.println("Hellow World");
    }

}



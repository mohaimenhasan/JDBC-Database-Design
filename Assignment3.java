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
             connection = DriverManager.getConnection(url, username, password);
        }
        catch (SQLException ex){
            return false;
        }
       
        return true;
    }

    @Override
    public boolean disconnectDB() {
	    //write your code here.
        try{
            connection.close();
        }
        catch (SQLException ex){
            return false;
        }
        return true;
    }

    @Override
    public ElectionResult presidentSequence(String countryName) {
            //Write your code here.
        try{
            PreparedStatement execStatement= connection.prepareStatement("select p.id, party.name from politician_president as p join party on party.id = p.party_id join country on p.country_id = country.id where country.name=? order by start_date desc");   
            execStatement.setString(1, countryName);
            ResultSet execResults = execStatement.executeQuery();
            List <Integer> pIDs = new ArrayList<Integer> ();
            List <String> party = new ArrayList<String> (); 
            while (execResults.next()){
                pIDs.add(execResults.getInt(1)); 
                party.add(execResults.getString(2)); 
            }

            ElectionResult returnThis = new ElectionResult(pIDs, party);
            return returnThis;
        }
        catch (SQLException ex){

        }

            return null;
	}

    @Override
    public List<Integer> findSimilarParties(Integer partyId, Float threshold) {
	//Write your code here.
        try{
                // find description of particular party
            PreparedStatement findPartyDescription = connection.prepareStatement("select description from party where id=?");
            findPartyDescription.setInt(1, partyId);
            ResultSet descriptionResults = findPartyDescription.executeQuery();
            List <String> givenDescriptions = new ArrayList<String> ();
            while (descriptionResults.next()){
                String addThis = descriptionResults.getString(1);
                if (addThis != null)
                    givenDescriptions.add(addThis); // if a party has more than one description
            }

                // find all other descriptions
            PreparedStatement execStatement = connection.prepareStatement("select description, id from party");
            ResultSet execResults = execStatement.executeQuery();
            List<Integer> finalAns = new ArrayList<Integer> ();

            // parse all the results
            while (execResults.next()){
                String description = execResults.getString(1); // this is the description of the individual string
                int party_id = execResults.getInt(2); // get the partyID
                if (party_id != partyId){    
                    // match it against other descriptions
                    for (int i=0; i < givenDescriptions.size(); i++){
                        String given = givenDescriptions.get(i);
                        double similarity_ = similarity(given, description);
                        if (similarity_ > threshold)
                            finalAns.add(party_id);                    
                    }
                }
            }
            return finalAns;
        }
        catch (SQLException ex){
            return null;
        }
        
    }

    public static void main(String[] args) throws Exception {
   	    //Write code here. 
	    System.out.println("Hellow World");
    }

}



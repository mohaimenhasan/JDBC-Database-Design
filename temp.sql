-- select president 

select p.id, party.name 
from politician_president as p join party on party.id = p.party_id join country on p.country_id = country.id 
where country.name=countryName order by start_date desc;

-- select description

select description from party;
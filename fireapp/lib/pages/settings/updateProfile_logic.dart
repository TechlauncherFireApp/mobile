
/* LOGIC */ 

// API = profile/editProfile
// Returns result = true/false
// Takes a JSON Object that looks like this 
/* 
  {
    "id": 4,
    "phone": 0000000000,
    "gender": "Female",
    "dietary": "vegetarian",
    "allergy": "none", 
  }
  ID is the primary key
  if you don't want to change an aspect then don't include it in the object

  Aspects that can be changed are;
  * Gender
  * Phone
  * Dietary
  * Allergy

  If you want the user to be able to change email, first name, last name that will require more changes to the API
*/
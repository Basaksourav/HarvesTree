package javaPackage;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Useful{

  //convert any string into title case
  public String toTitleCase (String str){
    StringBuilder newStr = new StringBuilder(str.length());

    //for each part by splitting the string
    for (String word : str.split("[ ,-/()]")){
      if (!word.equals("")){
        newStr.append (word.substring(0,1).toUpperCase());  //capitalize 1st letter
        newStr.append (word.substring(1).toLowerCase());    //keep the rest intact

        //if one or more parts remain
        if (newStr.length() < str.length()){
          for (int i = newStr.length(); i<str.length() && " .,-/()".indexOf(str.charAt(i))!=-1; i++) //until start of next part
            newStr.append (str.charAt(i));                                                          //keep original character
        }
      }
    }

    return newStr.toString();
  }

  //make hash of any string
  public String makeHash (String passwd){
    StringBuilder hash = new StringBuilder();

    try{
      MessageDigest sha = MessageDigest.getInstance ("SHA-1");
      byte[] bytes = passwd.getBytes();           //convert original text into byte stream 
      byte[] hashedBytes = sha.digest (bytes);    //create hashed byte stream by SHA-1
      char[] digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

      //string representation of hexadecimal form of hashed byte stream
      for (int i = 0; i < hashedBytes.length; i++){
        byte b = hashedBytes[i];
        hash.append (digits[(b & 0xf0) >> 4]);
        hash.append (digits[b & 0x0f]);
      }
    }
    catch(NoSuchAlgorithmException e){}

    return hash.toString();
  }
}
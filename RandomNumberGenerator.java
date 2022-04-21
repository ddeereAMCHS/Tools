import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class RandomNumberGenerator {
  public static void main(String[] args) {
    ArrayList<Integer> called = new ArrayList<Integer>();
    Random rand = new Random(System.currentTimeMillis());
    
    // get input
    Scanner in = new Scanner(System.in);
    System.out.print("Enter the number of students: ");
    int num = Integer.parseInt(in.nextLine());
    
    // generate random unique values from 1 to num
    while(called.size() < num) {
      int randNum = rand.nextInt(num) + 1;
      if(!called.contains(randNum)) { called.add(randNum); }
    }

    // print values in list
    for (Integer numCalled : called) {
      System.out.println(numCalled);
    }
  }
}
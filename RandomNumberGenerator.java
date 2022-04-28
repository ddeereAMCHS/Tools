import java.io.*;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class RandomNumberGenerator {
  public static void main(String[] args) throws IOException {
    // get input
    Scanner in = new Scanner(System.in);
    int input = 0;
    while (input < 1 || input > 2) {
      System.out.println("What would you like to do?");
      System.out.println("  1) read a file of names to shuffle");
      System.out.println("  2) enter a number and get a ");
      try { input = Integer.parseInt(in.nextLine()); }
      catch (NumberFormatException e) {}
    }

    switch (input) {
      case 1:
        System.out.print("Enter a filename: ");
        String filename = in.nextLine();
        readFileAndShuffle(filename);
        break;
      case 2:
        System.out.print("Enter a number: ");
        int number = Integer.parseInt(in.nextLine());
        ArrayList<Integer> numbers = generateRandomNumbers(number);
        for (Integer num : numbers) {
          System.out.println(num);
        }
        break;
      default: break;
    }
  }

  public static void readFileAndShuffle(String filename) throws IOException {
    Scanner fin = new Scanner(new File(filename));
    ArrayList<String> names = new ArrayList<String>();

    while (fin.hasNextLine()) {
      names.add(fin.nextLine());
    }

    names = shuffle(names);

    // print values in list
    for (String name : names) {
      System.out.println(name);
    }
  }

  // generate random unique values from 1 to num
  public static ArrayList<Integer> generateRandomNumbers(int num) {
    ArrayList<Integer> called = new ArrayList<Integer>();
    Random rand = new Random(System.currentTimeMillis());

    while(called.size() < num) {
      int randNum = rand.nextInt(num) + 1;
      if(!called.contains(randNum)) { called.add(randNum); }
    }

    return called;
  }

  // take an ArrayList (probably of names) and shuffle it
  public static <T> ArrayList<T> shuffle(ArrayList<T> list) {
    ArrayList<T> newList = new ArrayList<T>();
    ArrayList<Integer> numbers = generateRandomNumbers(list.size());

    for (int i = 0; i < numbers.size(); i++) {
      newList.add(list.get(numbers.get(i)-1));
    }

    return newList;
  }
}
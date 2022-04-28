import java.io.*;
import java.util.Scanner;

public class WordList {
  private static final int LENGTH = 8;
  private static final String STRLENGTH = "eight";

  public static void main(String[] args) throws IOException {
    Scanner fin = new Scanner(new File("words.txt"));
    FileWriter fout = new FileWriter("words-" + STRLENGTH + ".txt");

    while (fin.hasNextLine()) {
      String line = fin.nextLine();
      if (line.length() == LENGTH) { fout.write(line + "\n"); }
    }

    fout.close();
  }
}
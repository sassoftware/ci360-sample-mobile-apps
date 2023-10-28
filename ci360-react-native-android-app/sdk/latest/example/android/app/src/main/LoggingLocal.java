// public class logging {

// }

// Java Program to Demonstrate Redirection in
// System.out.println() By Creating .txt File
// and Writing to the file Using
// System.out.println()

// Importing required classes
import java.io.*;

// Main class
// SystemFact
public class LoggingLocal {

        // Main driver method
        public static void main(String arr[])
                        throws FileNotFoundException {

                // Creating a File object that
                // represents the disk file
                PrintStream o = new PrintStream(
                                new File("C:\\Users\\gazpat\\OneDrive - SAS\\Desktop\\tempLogs\\logsJava.txt"));

                // Store current System.out
                // before assigning a new value
                PrintStream console = System.out;

                // Assign o to output stream
                // using setOut() method
                System.setOut(o);

                // Display message only
                System.out.println(
                                "This will be written to the text file");

                // Use stored value for output stream
                System.setOut(console);

                // Display message only
                System.out.println(
                                "This will be written on the console!");
        }
}

///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS info.picocli:picocli:4.7.5

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

import java.io.File;
import java.util.concurrent.Callable;

@Command(name = "terraform", mixinStandardHelpOptions = true, version = "terraform 0.1",
        description = "Executes terraform plan and apply commands")
public class terraform implements Callable<Integer> {

    @Option(names = {"-d", "--directory"}, description = "Working directory for terraform commands")
    private File workingDirectory = new File(System.getProperty("user.dir"));

    @Option(names = {"-a", "--auto-approve"}, description = "Skip interactive approval for terraform apply")
    private boolean autoApprove = false;

    @Parameters(index = "0", description = "Command to execute (plan or apply)")
    private String command;

    public static void main(String... args) {
        int exitCode = new CommandLine(new terraform()).execute(args);
        System.exit(exitCode);
    }

    @Override
    public Integer call() throws Exception {
        if (!workingDirectory.exists()) {
            System.err.println("Error: Directory " + workingDirectory + " does not exist");
            return 1;
        }

        ProcessBuilder pb = new ProcessBuilder();
        pb.directory(workingDirectory);
        pb.inheritIO(); // Redirect process output to console

        switch (command.toLowerCase()) {
            case "plan":
                pb.command("terraform", "plan");
                break;
            case "apply":
                if (autoApprove) {
                    pb.command("terraform", "apply", "-auto-approve");
                } else {
                    pb.command("terraform", "apply");
                }
                break;
            default:
                System.err.println("Error: Unknown command. Use 'plan' or 'apply'");
                return 1;
        }

        Process process = pb.start();
        return process.waitFor();
    }
} 
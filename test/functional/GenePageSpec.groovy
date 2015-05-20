import org.codehaus.groovy.grails.plugins.webdriver.WebDriverHelper
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Rule
import org.junit.Test
import org.openqa.selenium.By
import org.openqa.selenium.TimeoutException
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.remote.DesiredCapabilities
import org.openqa.selenium.remote.RemoteWebDriver
import org.openqa.selenium.support.ui.ExpectedCondition
import org.openqa.selenium.support.ui.ExpectedConditions
import org.openqa.selenium.support.ui.WebDriverWait

import javax.annotation.Nullable
import java.text.DateFormat
import java.text.SimpleDateFormat

/**
 * Load tests the gene page by spawning a pile
 * of threads, each of which logs into the app
 * via google and then loads the gene page
 * for a different gene.
 */
class GenePageSpec {

    // 1. download and install chromedriver  https://sites.google.com/a/chromium.org/chromedriver/downloads.  Set -Dwebdriver.chrome.driver to the path to the executable.
    // 2. set -Dt2dportal.username and -Dt2dportal.password to the account you want to login with,
    // 3. DO NOT put username/password under source control
    // 4. adjust the number of concurrent threads by doing a sublist of the gene names
    // 5. if you end up with lots of chrome windows, run this little number
    // to kill the processes: kill $(ps aux | grep -i '\-\-test-type=webdriver' | awk '{print $2}')

    private static WebDriver driver;

    private Collection<Thread> browserThreads = new ArrayList<>();

    private List<String> passingTestSummaries = new ArrayList<>();

    @Test
    public void loadTestGenesPage() {

        Collection<String> genes = getGeneNames();
        Collections.shuffle(genes);
        for (String gene : genes[0..15]) {
            startGeneNameSearchThread(gene);
        }

        for (Thread thread : browserThreads) {
            thread.join();
        }

        for (String passingTestSummary : passingTestSummaries) {
            println(passingTestSummary);
        }
    }

    /**
     * Runs the gene search in a new thread
     */
    private void startGeneNameSearchThread(String geneName) {
        Thread t = new Thread(new Runnable() {
            @Override
            void run() {
                searchForGeneName(geneName);
            }
        });
        t.start();
        browserThreads.add(t);
    }

    /**
     * Spawns a new browser window, logs in via google,
     * and loads the gene page for the given gene.
     */
    private void searchForGeneName(String geneName) {
        String username = System.getProperty("t2dportal.username");
        String password = System.getProperty("t2dportal.password");


        WebDriver driver = new ChromeDriver();
        driver.get("http://type2diabetesgen-qasrvr.elasticbeanstalk.com/gene/geneInfo/" + geneName);

        WebElement googleLoginButton = driver.findElementByClassName("googleLoginButton");

        long signInStartTime = -1;
        if (googleLoginButton != null) {
            googleLoginButton.click();
            Thread.sleep(1000);
            driver.findElement(By.id("Email")).sendKeys(username);
            driver.findElement(By.id("Passwd")).sendKeys(password);
            signInStartTime = System.currentTimeMillis();
            driver.findElement(By.id("signIn")).click();
        }
        else {
            println("Already logged in?")
        }

        WebDriverWait wait = new WebDriverWait(driver, 10);
        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(By.linkText("T2D-GENES consortium")));
        }
        catch(TimeoutException e) {
            println(geneName + ": GOOGLE LOGIN FAILED");
            return;
        }
        println("It took " + (System.currentTimeMillis() - signInStartTime) + "ms to sign in via google for " + geneName);

        DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS")
        println("Querying " + geneName + " at " + dateFormat.format(System.currentTimeMillis()));
        long startTime = System.currentTimeMillis();
        driver.get("http://type2diabetesgen-qasrvr.elasticbeanstalk.com/gene/geneInfo/" + geneName);

        wait = new WebDriverWait(driver, 60);
        try {
            wait.until(new ExpectedCondition<Boolean>() {
                @Override
                Boolean apply(@Nullable WebDriver webDriver) {
                    boolean hasTableRendered = 3 == driver.findElements(By.xpath("//table[@id='variantsAndAssociationsTable']/tbody/tr")).size();
                    return hasTableRendered;
                }
            });
        }
        catch(TimeoutException e) {
            println(geneName + ": FAILED");
            return;
        }

        long timeToRenderTable = System.currentTimeMillis() - startTime;
        passingTestSummaries.add(geneName + ": " + (timeToRenderTable/1000f) + " seconds, started at " + dateFormat.format(startTime));

    }

    private String[] getGeneNames() {
        return [
                "HIST1H1D",
                "MDC1",
                "C20orf141",
                "MAP4",
                "SLC41A3",
                "ZMYM1",
                "SSTR5",
                "HEBP2",
                "ARHGEF17",
                "CCDC78",
                "PSME4",
                "IL2RA",
                "LAMA2",
                "FAM160A2",
                "BTN2A2",
                "ORC4",
                "CACTIN",
                "HSPB1",
                "MAN2A1",
                "LSM3",
                "DNAJC16",
                "CHTF18",
                "IGFN1",
                "TAF4B",
                "MORC2",
                "TMUB2",
                "BCL2L2-PABPN1",
                "NUFIP1",
                "SLC39A13",
              "PTTG2"
        ]
    }

}

<h1>Diabetes portal</h1>

The diabetes portal is written in Grails. The following description should give you all the information you need to download, compile, and run a local version of the portal.

<h3>Table of Contents:</h3>
<dl>
<dt>Environment</dt><dd> Set up your environment for running a Grails based project</dd>
<dt> Get the code</dt><dd> Download the code from GitHub</dd>
<dt> Testing</dt><dd>Run some pre-packaged tests to make sure your environment  is in good shape</dd>
<dt>Run the portal</dt><dd>Start up the diabetes portal and run it locally</dd>
</dl>

<h2>Environment</h2>

   The following steps should give you a working development environment:

<h4>Install Java (this is the toughest step)</h4>
<p>
Googling “download Java jdk” should take you where you need to go. The same command brought me to this 
<a href="http://www.oracle.com/technetwork/java/javaee/downloads/java-ee-sdk-6u3-jdk-7u1-downloads-523391.html">URL</a>
from which I successfully downloaded Java.
</p>

<p>
Note that you will need the whole Java development toolkit (JDK), not simply the Java runtime environment (JRE).
As far as versions, I have successfully compiled this program both under Java 6 and Java 7 (I haven't yet tried Java 8).
</p>

<p>
Once you’ve downloaded Java you should run the installer.  Make sure that one way or another you end up with an environmental variable named “<tt>JAVA_HOME</tt>” which points
at the base directory of your JDK.
I usually perform this assignment inside my .bash_profile with a few lines that look like this:  
</p>

```bash
JAVA_HOME=/cygdrive/c/java7
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME
```
<p>
Other approaches to defining an environmental variable are fine too.  Simply make sure that if you type:
</p>

```bash
echo $JAVA_HOME
```

<p>
that you see the directory you expect to see.    The critical test of your success  in this step, however, is  typing
</p>

```bash
java -version
```

<p>
which should report  the version of your Java runtime environment.
</p>

<h4>Install GVM</h4>

<p>
There’s a tool called GVM that can do most of the rest of the installation work for you.  You can find that tool at the following URL <tt>http://gvmtool.net/</tt>.
You start by installing GVM, which has only two dependencies, namely ‘curl’ and ‘unzip’.  These are essential-- if you don't have them installed then you cannot
proceed with GVM.  To be sure you can certainly install grails without GVM if you like.  Check the instructions <a href="https://grails.org/">here</a>.</p>

<p>
Provided that you want to proceed with GVM, use the following command line evocation:
</p>

```bash
 curl -s get.gvmtool.net | bash
```
<p>
   Once this line runs successfully the rest of the install becomes pretty easy.
</p>

  <h4>Install Grails</h4>
<p>
   with GVM in place installing grails should consist of exactly one line:</p>

```bash
   gvm install grails 2.4.3
```

<p>
   Once this command completes successfully you should be able to run the following command from the command line (Note the extra - that the analogous Java command does not require): </p>

```bash
   grails –-version
```

 and you should see a response that indicates that grails is working and running  the version number you requested

<h4>Install Groovy</h4>
<p>
 Not strictly necessary (since grails comes  with its own version of groovy built-in) but you may as well having come this far
 </p>

```bash
   gvm install groovy
```

If your Groovy installation  completed successfully then the following command will tell you that Groovy is running


```bash
groovy --version
```

<p>
To be clear, you can run grails without  installing Groovy explicitly.  If you do install Groovy explicitly, however, then you can begin writing programs
in straight up Groovy as well, which has its own attractions.
Groovy is a really fun language with lots of possibilities. Check out the documentation  <a href="http://groovy.codehaus.org/">here</a>
</p>

<h2>Get the code</h2>

<p>
Now it’s time to pull down the code from the repository. Provided that you have already installed a git client this can be accomplished with one line</p>

```bash
git clone git@github.com:broadinstitute/dig-diabetes-portal.git
```

<p>
Git will create a new directory called dig-diabetes-portal.  Change your current working directory and then you will be ready to start building the system.
</p>

<p>
While your cloning repos note that both  Groovy and Grails have their own repo, and that you can download the source code for either or both languages.  Each
of these repos is instructive and worth going through, especially if you get stuck somewhere along the way.  For the record, note that Groovy is
written mostly in Java (though there is currently a project underway to  rewrite Groovy in Groovy).  Grails, by comparison, is written
mostly in Groovy.
</p>


<h2>Testing/h2>

<p>
A good place to start might be with running the tests. You can run the unit tests with the following command: </p>


```bash
grails test-app unit:
```

<p>
You can run integration tests with this command:</p>


```bash
grails test-app integration:
```

<p>
Skipping the 'unit' or 'integration' specification will cause the entire test suite to run. Conversely adding a class name
to the end of one of the earlier commands  will allow you to run  only a single test.</p>


<h2>Run the portal</h2>

<p>
Once you have demonstrated that you can run both tests to completion you can be reasonably confident that your environment is in good 
shape and that you are ready to run the portal. The command looks like this: </p>

```bash
grails run-app
```

<p>
this command should be all you need to start a running application from the command line.  If you'd like to do some development, however,
you will probably want to import the project into an IDE.  I like <a href="http://www.jetbrains.com/idea/">IntelliJ</a>, though there is also
an active community of Grails developers
who use eclipse.   If you would like to prepare your project  for an IDE then there is a grails command for that.  To open
up the project in IntelliJ, for example, the command is:  </p>

```bash
grails integrate-with --intellij
```

<p>
which will generate an "*.ipr" file along with everything else you need to open the fully functional project under  IntelliJ</p>


<p>
Just for the record, if you want to now deploy a  the portal you would need to use grails to create a WAR file that you could
then the handoff to a suitable servlet container  such as Apache or Tomcat.  The grails command necessary to create a war file
is:</p>


```bash
grails war
```

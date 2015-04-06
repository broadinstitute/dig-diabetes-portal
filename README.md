
__Important note to portal developers and sysops (current February 3, 2015)__
__After we make the move our 
new Google sign-on based authentication system, please note that the code will no longer run unless you
incorporate a private configuration file, as described below in the section titled "Configuration".  The code
should compile correctly without private configuration files, but it will not run in any of the following configurations:
  * debug mode for development
  * test mode, for running unit, integration, or functional tests
  * generating a war file for the purposes of deployment
  * running that war file on your target server
More information is provided down below (see the "configuration" section in this README file)__

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

<h4>Install Java</h4>
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
with GVM in place installing grails should consist of exactly one line:
</p>

```
gvm install grails 2.4.3
```

<p>
Once this command completes successfully you should be able to run the following command from the command line (Note the extra - that the analogous Java command does not require):
</p>


```
grails –-version
```

<p>
and you should see a response that indicates that grails is working and running  the version number you requested
</p>

<p>
A quick note for Mac users: homebrew also provides an easy approach to perform the Grails installation.  And while we're on the topic
installing Grails by hand is also quite easy.  You download the package and set a GRAILS_HOME environmental variable and you're all set.
</p>

<h4>Install Groovy</h4>

<p>
Not strictly necessary (since grails comes  with its own version of groovy built-in) but you may as well having come this far
</p>


```
gvm install groovy
```

<p>
If your Groovy installation  completed successfully then the following command will tell you that Groovy is running
</p>


```
groovy --version
```

<p>
To be clear, you can run grails without  installing Groovy explicitly.  If you do install Groovy explicitly, however, then you can begin writing programs
in straight up Groovy as well, which has its own attractions.
Groovy is a really fun language with lots of possibilities. Check out the documentation  <a href="http://groovy.codehaus.org/">here</a>
</p>

<h2>Get the code</h2>

<p>
Now it’s time to pull down the code from the repository. Provided that you have already installed a git client this can be accomplished with one line
</p>

```
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


<h2>Testing</h2>

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
If you want to now deploy a  the portal you would need to use grails to create a WAR file that you could
then the handoff to a suitable servlet container  such as Apache or Tomcat.  The grails command necessary to create a war file by hand is:</p>


```bash
grails war
```

In order to increase consistency a bash script exists to build war files.  This script is named 'gpw', and it passes
a few parameters in as the war is created making the resulting executable easier to track.  To run this script
enter the following command from a bash-aware command prompt:


```bash
./gpw nameForThisVersion
```

Note that this script performs a 'git rev-parse HEAD' in order to determine your current git repo version, so your
command line interface needs to recognize 'git'.

<h4>Configuration</h4>

While the diabetes portal is open source at its core, there are a few keys ( mostly relevant to authentication and
services we pay for) which need to remain secret. As well, you may choose to override some of the default values
utilized by the portal during compilation. In both cases you'll need to utilize a private configuration file
that is stored somewhere on a local disk. The portal is looking for such a private configuration file. To determine
the directory that should hold your private config, try running the above 'gpw' command and watch the resulting
console output to find a line that look something like this:

```bash
>>>>>>>>>>>Note to developers: config files may be placed in the directory  = /Users/ben/.grails/dig-diabetes-portal
```

This line will tell you where on disk to store your private configuration file. In that directory you may then
create a file  named 'dig-diabetes-portal-commons-config.groovy'.  This file will now be read in by grails
during the compilation phase, and any values listed in this file will override those listed in the portals
default configuration file (named Config.groovy).  Any values not explicitly overridden will retain their default values.
You will know that you have created a personal configuration file in the right place and with the right name if you see   lines similar to the following when you compile the portal using gpw.

```bash
\*\* !! config override is in effect !! \*\*
\!\!\!\!\! file:/Users/ben/.grails/dig-diabetes-portal/dig-diabetes-portal-commons-config.groovy !! **
```

Note that a personal configuration file will (very) soon become mandatory, and that this file will need to contain
at a minimum the following line:

```bash
oauth.providers.google.api.secret = 'xxxxxxx'
```
where *xxxxxxx* represents our Google OAuth secret key.  For developers working on the diabetes portal in
the Medical Population Genomics department at the Broad Institute then please see me (ba) for our current key.
Otherwise set up your own authorization secret key with Google and replace *xxxxxxx* with your number.  

Special note: if you don't create the above configuration file, or else if you put it in the wrong place then 
two things will happen:  first, during compilation the Grails code will give you a polite, comprehensible message
indicating that you did not supply a configuration file. That message will Show up on your console, and should 
look something like this:

```bash
\*\* No config override  in effect \*\*
```

as well, Grails will error out without running, and will provide a long and barely comprehensible error message
that starts out looking like this:

```bash
Error |
Fatal error running tests: Error creating bean with name 'grails.plugin.databasemigration.DbdocController': 
Initialization of bean failed; nested exception is org.springframework.beans.factory.BeanCreationException: 
Error creating bean with name 'instanceControllerTagLibraryApi': 
Injection of autowired dependencies failed; nested exception is org.springframework.beans.factory.BeanCreationException: Could not autowire method: 
public void org.codehaus.groovy.grails.plugins.web.api.ControllerTagLibraryApi.setTagLibraryLookup(org.codehaus.groovy.grails.web.pages.TagLibraryLookup); 
nested exception is org.springframework.beans.factory.BeanCreationException: 
Error creating bean with name 'gspTagLibraryLookup': 
Invocation of init method failed; 
nested exception is org.springframework.beans.factory.BeanCreationException: 
Error creating bean with name 'grails.plugin.springsecurity.oauth.SpringSecurityOAuthTagLib': 
Initialization of bean failed; nested exception is org.springframework.beans.factory.BeanCreationException: 
Error creating bean with name 'oauthService': 
Invocation of init method failed; nested exception is java.lang.IllegalStateException: 
Missing oauth secret or key (or both!) in configuration for google. (Use --stacktrace to see the full trace)
.Tests FAILED 
|
```

So if you see the above message, look to see if you have a configuration file, if it is in the right place, and if
it contains the right values.

<h2>Development tools:</h2>

<h3>Code coverage</h3>
```bash
 grails test-app -coverage
```
and see ./target/test-reports/cobertura

<h3>Automated code Checker</h3>
```bash
 grails codenarc
```
and find your summary report in ./target/CodeNarcReport.html

<h3>CI system and version promotion</h3>

We have a process to move from code push to production deploy. It looks like this:
<ul>
<li>1) every time a developer pushes code:</li> 
<li>1.1) the CI system pulls my code from git
<li>1.2) the system runs all the unit and integration tests. IF they pass then
<li>1.3) CI deploys, and gives that version a CI git tag. Then…
<li>2) every morning at 2 AM
<li>2.1) the tag describing last successfully deployed CI version is pulled from git
<li>2.2) the system runs all the unit and integration tests. IF they pass then
<li>2.3) dev deploys, and gives that version a DEV git tag.
<li>2.4) developers look at the deployed dev system, and decide whether they like it. If they do then…
<li>3) a developer goes to the Jenkins project named 'MANUAL-deployedToQA'
<li>3.1) the developer goes in with the name of a DEV tag in mind. The developer chooses that tag from the drop-down list, then presses the 'Build' button
<li>3.2) the system runs all the unit and integration tests. IF they pass then
<li>3.3) the system BRANCHES the code, and deploys that branch to QA
<li>3.4) developers look at the system themselves, but also request the attention of nondevelopers (presumably Mary) to see if this system is acceptable. If it is then...
<li>4) a developer goes to the Jenkins project named 'MANUAL-deployedToQA', presumably during nonpeak hours
<li>4.1) the developer goes in with the name of a DEV tag in mind. The developer chooses that tag from the drop-down list, then presses the 'Build' button
<li>4.2) the system runs all the unit and integration tests. IF they pass then
<li>4.3) the system BRANCHES the code again, and deploys that branch to PROD
</ul>
done. Code has been deployed to PROD.

Note: This entire process should be completed once per iteration (or more, if any problems are discovered after the deployment). This deployment should happen at least a 
couple of days before the user group, so that the group can help take a look at the newly minted production code.






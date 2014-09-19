<h1>Diabetes portal</h1>

The diabetes portal is written in Grails. The following description should give you all the information you need to download, compile, and run a version of the portal.

<h3>Document contents</h3>
<dl>
<dt>Environment</dt><dd> Set up your environment for running a Grails based project</dd>
<dt> Get the code</dt><dd> Download the code from GitHub</dd>
<dt> Testing</dt><dd>Run some prepackaged tests to make sure your environment  is in good shape</dd>
<dt>Run your portal</dt><dd>Start up the diabetes portal and run it locally</dd>
</dl>

<h2>Environment</h2>

   The following steps should give you a working development environment:

<h3>Install Java (this is the toughest step)</h3>
<p>
Googling “download Java jdk” should take you where you need to go. The same command brought me to the URL:<br/>
<tt>http://www.oracle.com/technetwork/java/javaee/downloads/java-ee-sdk-6u3-jdk-7u1-downloads-523391.html</tt><br/>
which seems like a good place to start.
</p>

<p>
Note that you will need the whole Java development toolkit (JDK), not simply the Java runtime environment (JRE).
As far as versions, I have successfully compiled this program both under Java 6 and Java 7
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
   But if you have a different approach than I’m sure that’s fine too.</p>

<h3>Install GVM</h3>

<p>
   There’s a tool called GVM that can do most of the rest of the installation work for you.  You can see that tool at the following URL <tt>http://gvmtool.net/</tt>.
   You start by installing GVM, which has only two dependencies, namely ‘curl’ and ‘unzip’.  If you don’t have those installed then install them.
   If you do then you can proceed to install GVM with the following command line evocation:
</p>

```bash
 curl -s get.gvmtool.net | bash
```
<p>
   Once this line runs successfully the rest of the install should be pretty easy.
</p>

  <h3>Install grails</h3>
<p>
   with GVM in place installing grails should consist of exactly one line:</p>

```bash
   gvm install grails 2.4.3
```

<p>
   Once this command completes successfully you should be able to run the following command from the command line: </p>

```bash
   Grails –version
```
   and you should see a response that indicates that grails is working.
  <h3>Install groovy</h3>
<p>
   Not strictly necessary but you may as well having come this far   </p>

```bash
   gvm install groovy
```

<h2>Get the code</h2>

<p>
Now it’s time to pull down the code from the repository. Provided that you have already installed a git client this can be accomplished with one line</p>

```bash
git clone git@github.com:broadinstitute/dig-diabetes-portal.git
```

<p>
Git will create a new directory called dig-diabetes-portal.  Make this your current working directory and then you will be ready to start building the system.</p>

<h2>Run the tests</h2>

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

<h2>Start up the portal</h2>

<p>
Once you have demonstrated that you can run both tests to completion you can be reasonably confident that your environment is in good 
shape and that you are ready to run the portal. The command looks like this: </p>

```bash
grails run-app
```

<p>
this command should be all you need to start a running application from the command line.  If you'd like to do some development, however,
you will probably want to import the project into an IDE.  I like IntelliJ (though there is an active community of Grails developers
who use eclipse).   If you would like to prepare your project  for an IDE then there is a grails command for that.  To open
up the project in IntelliJ, for example, the command is:  </p>

```bash
grails IW --intellij
```

<p>
which will generate an "*.ipr" file along with everything else you need to open the fully functional project under   IntelliJ</p>

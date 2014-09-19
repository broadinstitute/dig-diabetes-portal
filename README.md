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
   Googling “download Java jdk” should take you where you need to go. The same command brought me to the URL:
   <tt>http://www.oracle.com/technetwork/java/javaee/downloads/java-ee-sdk-6u3-jdk-7u1-downloads-523391.html</tt>
   which seems like a good place to start.</p>

   <p>
   Note that you will need the whole Java development toolkit (JDK), not simply the Java runtime environment (JRE).
   As far as versions, I have successfully compiled this program both under Java 6 and Java 7 (I have not yet tried Java 8). </p>

   <p>
   Once you’ve downloaded Java you should run the installer.  Make sure that one way or another you end up with an environmental variable named “<tt>JAVA_HOME</tt>” which points
    at the base directory of your JDK.
   I usually perform this assignment inside my .bash_profile with a few lines that look like this:  </p>

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
   If you do then you can proceed to install GVM with the following command line evocation:  </p>

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


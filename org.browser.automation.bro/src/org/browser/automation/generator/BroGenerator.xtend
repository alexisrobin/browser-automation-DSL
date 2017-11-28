/*
 * generated by Xtext 2.10.0
 */
package org.browser.automation.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.browser.automation.bro.BrowserFlow
import java.io.File
import org.browser.automation.bro.Browser
import org.browser.automation.bro.BrowserAction
import org.browser.automation.bro.Instanciation
import org.browser.automation.bro.DOMFlow
import org.browser.automation.bro.By
import org.browser.automation.bro.Go
import org.browser.automation.bro.Wait
import org.browser.automation.bro.DOMAction
import org.browser.automation.bro.VarCall
import org.browser.automation.bro.VarSuffix

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class BroGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		var browserFlow = resource.contents.head as BrowserFlow
		var sep = File.separator

		//Building a platform independent URI
		var filePath = 'bro'+sep+'LaunchBrowserAutomation.java';
		
		fsa.generateFile(filePath, browserFlow.compile)	
	}
	
	def instantiateDriver(Browser b) '''
		«IF b == Browser.CHROME»
			WebDriver driver = new ChromeDriver();
		«ELSEIF b == Browser.FIREFOX»
			WebDriver driver = new FireFoxDriver();
		«ELSEIF b == Browser.SAFARI»
			WebDriver driver = new SafariDriver();
		«ENDIF»
	'''
	
	def dispatch compile(BrowserFlow bFlow) '''
		package bro;

		import org.openqa.selenium.By;
		import org.openqa.selenium.WebDriver;
		import org.openqa.selenium.WebElement;
		import org.openqa.selenium.chrome.ChromeDriver;
		import org.openqa.selenium.support.ui.ExpectedCondition;
		import org.openqa.selenium.support.ui.WebDriverWait;

		
		public class LaunchBrowserAutomation {

			public static void main(String[] args) {
				«FOR Browser browser : bFlow.browsers»
					«browser.instantiateDriver»
					«FOR BrowserAction bAction : bFlow.browserActions»
						«bAction.compile» 
					«ENDFOR»
				«ENDFOR»
			}
		}
	'''
	
	def dispatch compile(Instanciation instanciation) '''
		«IF instanciation.by == By.BY_NAME»
			WebElement «instanciation.getVar().name»  = driver.findElement(By.name("«instanciation.getStr()»"));
		«ELSE »
			WebElement «instanciation.getVar().name»  = driver.findElement(By.id("«instanciation.getStr()»"));
		«ENDIF »
	'''
	
	def dispatch compile(Go go) '''
		driver.get("«go.getDest()»");
	'''
	
	def dispatch compile(Wait wait) '''
		driver.manage().timeouts().implicitlyWait(«wait.getTime()», TimeUnit.SECONDS);
	'''

	def dispatch compile(DOMFlow dFlow) '''
		«FOR VarCall varCall : dFlow.variables»
			«FOR DOMAction dAction : dFlow.domActions»
				«varCall.getVar().name»«IF varCall.getSuffix() == VarSuffix.FIRST».get(0)«ENDIF» = «dAction.compile» 
			«ENDFOR»
		«ENDFOR»
	'''
	
	def dispatch compile(DOMAction dAction) '''
		truc
	'''
	
	
}

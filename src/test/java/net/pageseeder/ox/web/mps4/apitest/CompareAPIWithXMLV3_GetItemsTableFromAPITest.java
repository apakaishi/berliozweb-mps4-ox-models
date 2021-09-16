/* Copyright (c) 2021 Allette Systems pty. ltd. */
package net.pageseeder.ox.web.mps4.apitest;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.pageseeder.ox.step.StepSimulator;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * I calls with the generic methods for this for the pipeline "pdf-psml" in the model "pdf"
 *
 * @author ccabral
 * @since 21 May 2021
 */
public class CompareAPIWithXMLV3_GetItemsTableFromAPITest extends CompareAPIWithXMLV3Test {
  private static File INPUT = null;
  private static File EXPECTED_RESULT_DIRECTORY = null;
  private static Map<String, String> REQUEST_PARAMETER = null;

  @BeforeClass
  public static void init () {
    CompareAPIWithXMLV3Test.init();
    INPUT = new File("src/test/resources/net/pageseeder/ox/web/mps4/apitest/");
    EXPECTED_RESULT_DIRECTORY = new File("src/test/resources/net/pageseeder/ox/web/mps4/apitest/");
    REQUEST_PARAMETER = CompareAPIWithXMLV3Test.getDefaultRequestParameters();
  }

  @Test
  public void getItemsTableFromAPI() {
    try {
      StepSimulator simulator = new StepSimulator(super.getModel().name(), this.INPUT, this.REQUEST_PARAMETER);
      super.performGetItemsTableFromAPI(simulator);

      List<File> filesToIgnore = new ArrayList<>();
      //super.validateXML("files/final", simulator, filesToIgnore);
    } catch (Exception ex) {
      ex.printStackTrace();
      Assert.fail(ex.getMessage());
    }
  }


  @Override
  protected File getExpectedResultDirectory() {
    return EXPECTED_RESULT_DIRECTORY;
  }
}

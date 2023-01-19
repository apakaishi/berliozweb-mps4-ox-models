package net.pageseeder.ox.web.mps4.embargo;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.pageseeder.ox.api.Result;
import org.pageseeder.ox.core.ResultStatus;
import org.pageseeder.ox.step.StepSimulator;
import org.pageseeder.xmlwriter.XML;
import org.pageseeder.xmlwriter.XMLStringWriter;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author vku
 * @since 04 November 2021
 */
public class MPS4EmbargoAddMetadata_performExtractDataTest extends MPS4EmbargoAddMetadataTest {
  private static Map<String, String> REQUEST_PARAMETER = null;

  @BeforeClass
  public static void init () {
    MPS4EmbargoAddMetadataTest.init();
    REQUEST_PARAMETER = MPS4EmbargoAddMetadataTest.getDefaultRequestParameters();
  }

  @Test
  public void performExtractData() {
    try {
      File input = new File("src/test/resources/net/pageseeder/ox/web/mps4/addmetadata/basic/embargo-add-metadata-test.xlsx");
      StepSimulator simulator = new StepSimulator(super.getModel().name(), input, REQUEST_PARAMETER);
      Result result = super.performExtractDataFromSpreadsheet(simulator);
      if (!ResultStatus.OK.equals(result.status())) {
        XMLStringWriter writer = new XMLStringWriter(XML.NamespaceAware.No);
        result.toXML(writer);
        System.out.println("Result");
        System.out.println(writer);
      }
      Assert.assertEquals(ResultStatus.OK, result.status());
      List<File> filesToIgnore = new ArrayList<>();
      super.validateXML("data", simulator, filesToIgnore);
    } catch (Exception ex) {
      ex.printStackTrace();
      System.out.println(ex.getMessage());
      Assert.fail(ex.getMessage());
    }
  }

  @Override
  protected File getExpectedResultDirectory() {
    return new File("src/test/resources/net/pageseeder/ox/web/mps4/addmetadata/basic/result/");
  }
}


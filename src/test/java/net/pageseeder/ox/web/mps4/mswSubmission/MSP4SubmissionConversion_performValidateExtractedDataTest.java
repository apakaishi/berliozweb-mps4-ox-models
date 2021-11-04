package net.pageseeder.ox.web.mps4.mswSubmission;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.pageseeder.ox.api.Result;
import org.pageseeder.ox.core.ResultStatus;
import org.pageseeder.ox.step.StepSimulator;
import org.pageseeder.xmlwriter.XML;
import org.pageseeder.xmlwriter.XMLStringWriter;

import java.io.File;
import java.util.Map;

/**
 * @author vku
 * @since 04 November 2021
 */
public class MSP4SubmissionConversion_performValidateExtractedDataTest extends MPS4SubmissionConversionTest{
  private static File INPUT = null;
  private static Map<String, String> REQUEST_PARAMETER = null;

  @BeforeClass
  public static void init () {
    MPS4SubmissionConversionTest.init();
    INPUT = new File("src/test/resources/net/pageseeder/ox/web/mps4/mswSubmission/msw-data-source-spreadsheet-test.xlsx");
    REQUEST_PARAMETER = MPS4SubmissionConversionTest.getDefaultRequestParameters();
  }

  @Test
  public void performValidateExtractedData() {
    try {
      StepSimulator simulator = new StepSimulator(super.getModel().name(), INPUT, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      Result result = super.performValidateExtractedData(simulator);
      if (!ResultStatus.OK.equals(result.status())) {
        XMLStringWriter writer = new XMLStringWriter(XML.NamespaceAware.No);
        result.toXML(writer);
        System.out.println(writer);
      }
      Assert.assertEquals(ResultStatus.OK, result.status());
    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Override
  protected File getExpectedResultDirectory() {
    return null;
  }
}


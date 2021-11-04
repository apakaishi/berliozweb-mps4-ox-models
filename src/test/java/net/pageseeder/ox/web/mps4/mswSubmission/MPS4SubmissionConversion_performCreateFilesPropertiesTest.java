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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author vku
 * @since 04 November 2021
 */
public class MPS4SubmissionConversion_performCreateFilesPropertiesTest extends MPS4SubmissionConversionTest {
  private static File INPUT = null;
  private static File EXPECTED_RESULT_DIRECTORY = null;
  private static Map<String, String> REQUEST_PARAMETER = null;

  @BeforeClass
  public static void init () {
    MPS4SubmissionConversionTest.init();
    INPUT = new File("src/test/resources/net/pageseeder/ox/web/mps4/mswSubmission/msw-data-source-spreadsheet-test.xlsx");
    EXPECTED_RESULT_DIRECTORY = new File("src/test/resources/net/pageseeder/ox/web/mps4/mswSubmission/successful/result/");
    REQUEST_PARAMETER = MPS4SubmissionConversionTest.getDefaultRequestParameters();
  }

  @Test
  public void performCreateFilesProperties() {
    try {
      StepSimulator simulator = new StepSimulator(super.getModel().name(), INPUT, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      super.performValidateExtractedData(simulator);
      Result result = super.performCreateFilesProperties(simulator);
      Assert.assertEquals(ResultStatus.OK, result.status());
      List<File> filesToIgnore = new ArrayList<>();
      super.validateXML("bus-documents", simulator, filesToIgnore);
    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Override
  protected File getExpectedResultDirectory() {
    return EXPECTED_RESULT_DIRECTORY;
  }
}

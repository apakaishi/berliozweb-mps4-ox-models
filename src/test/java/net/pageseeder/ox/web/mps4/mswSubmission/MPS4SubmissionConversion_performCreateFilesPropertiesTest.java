package net.pageseeder.ox.web.mps4.mswSubmission;

import org.junit.Assert;
import org.junit.Before;
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

  private static String inputFieldsBase = null;

  @BeforeClass
  public static void init () {
    MPS4SubmissionConversionTest.init();
    INPUT = new File("src/test/resources/net/pageseeder/ox/web/mps4/mswSubmission/msw-data-source-spreadsheet-test.xlsx");
    EXPECTED_RESULT_DIRECTORY = new File("src/test/resources/net/pageseeder/ox/web/mps4/mswSubmission/successful/result/");
    inputFieldsBase = "src/test/resources/net/pageseeder/ox/web/mps4/mswSubmission/";
  }

  @Before
  public void reset() {
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

  /**
   * Test the following fields added through OX frontend when they are empty or not present in the input spreadsheet
   * Meeting Date
   * Step 1 - Status
   * Step 2 - Status
   * Step 2 - Open Date
   * Step 2 - Closed Date
   * Step 2 - See URL
   * Step 2 - See URL Title
   * Step 3 - Status
   * Step 4 - Status
   */
  @Test
  public void addInputFieldsAllEmpty() {
    File input = new File(inputFieldsBase, "input-fields-all/inputFieldTest.xlsx");
    File expected = new File(inputFieldsBase, "input-fields-all/bus-documents");
    try {
      REQUEST_PARAMETER.put("meeting-date", "2022-11-23");
      REQUEST_PARAMETER.put("step1-status", "Canceled");
      REQUEST_PARAMETER.put("step2-status", "Active");
      REQUEST_PARAMETER.put("step2-open-date", "1999-09-09");
      REQUEST_PARAMETER.put("step2-closed-date", "1999-09-09");
      REQUEST_PARAMETER.put("step2-see-url", "https://www.pbs.gov.au/info/browse/statistics#Medicare");
      REQUEST_PARAMETER.put("step2-see-url-title", "Medicare Statistics - PBS Item and Group reports");
      REQUEST_PARAMETER.put("step3-status", "Canceled");
      REQUEST_PARAMETER.put("step4-status", "Active");
      StepSimulator simulator = new StepSimulator(super.getModel().name(), input, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      super.performValidateExtractedData(simulator);
      Result result = super.performCreateFilesProperties(simulator);
      Assert.assertEquals(ResultStatus.OK, result.status());
      File[] dirFiles = expected.listFiles();
      if (dirFiles != null) {
        for (File file : dirFiles) {
          String fileName = "bus-documents/" + file.getName();
          super.compareActualExpected(file, fileName, simulator);
        }
      }
    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Test
  public void addInputFieldsSome() {
    File input = new File(inputFieldsBase, "input-fields-some/inputFields.xlsx");
    File expected = new File(inputFieldsBase, "input-fields-some/bus-documents");
    try {
      REQUEST_PARAMETER.put("meeting-date", "");
      REQUEST_PARAMETER.put("step1-status", "Canceled");
      REQUEST_PARAMETER.put("step2-status", "Active");
      REQUEST_PARAMETER.put("step2-open-date", "1999-09-09");
      REQUEST_PARAMETER.put("step2-closed-date", "1999-09-09");
      REQUEST_PARAMETER.put("step2-see-url", "https://www.pbs.gov.au/info/browse/statistics#Medicare");
      REQUEST_PARAMETER.put("step2-see-url-title", "Medicare Statistics - PBS Item and Group reports");
      REQUEST_PARAMETER.put("step3-status", "Canceled");
      REQUEST_PARAMETER.put("step4-status", "Active");
      StepSimulator simulator = new StepSimulator(super.getModel().name(), input, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      super.performValidateExtractedData(simulator);
      Result result = super.performCreateFilesProperties(simulator);
      Assert.assertEquals(ResultStatus.OK, result.status());
      File[] dirFiles = expected.listFiles();
      if (dirFiles != null) {
        for (File file : dirFiles) {
          String fileName = "bus-documents/" + file.getName();
          super.compareActualExpected(file, fileName, simulator);
        }
      }
    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Test
  public void addInputFieldsOpenClosedDate() {
    File input = new File(inputFieldsBase, "input-fields-openClosedDate/inputFields.xlsx");
    File expected = new File(inputFieldsBase, "input-fields-openClosedDate/bus-documents");
    try {
      REQUEST_PARAMETER.put("meeting-date", "");
      REQUEST_PARAMETER.put("step1-status", "");
      REQUEST_PARAMETER.put("step2-status", "");
      REQUEST_PARAMETER.put("step2-open-date", "1999-09-09");
      REQUEST_PARAMETER.put("step2-closed-date", "1999-09-09");
      REQUEST_PARAMETER.put("step2-see-url", "");
      REQUEST_PARAMETER.put("step2-see-url-title", "");
      REQUEST_PARAMETER.put("step3-status", "");
      REQUEST_PARAMETER.put("step4-status", "");
      StepSimulator simulator = new StepSimulator(super.getModel().name(), input, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      super.performValidateExtractedData(simulator);
      Result result = super.performCreateFilesProperties(simulator);
      Assert.assertEquals(ResultStatus.OK, result.status());
      File[] dirFiles = expected.listFiles();
      if (dirFiles != null) {
        for (File file : dirFiles) {
          String fileName = "bus-documents/" + file.getName();
          super.compareActualExpected(file, fileName, simulator);
        }
      }
    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Override
  protected File getExpectedResultDirectory() {
    return EXPECTED_RESULT_DIRECTORY;
  }
}

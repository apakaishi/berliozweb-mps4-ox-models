package net.pageseeder.ox.web.mps4.embargo;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.pageseeder.ox.api.Result;
import org.pageseeder.ox.core.ResultStatus;
import org.pageseeder.ox.step.StepSimulator;

import java.io.File;
import java.util.Map;

/**
 * @author vku
 * @since 04 November 2021
 */
public class MPS4EmbargoAddMetadata_performValidateExtractedDataTest extends MPS4EmbargoAddMetadataTest {
  private static Map<String, String> REQUEST_PARAMETER = null;

  @BeforeClass
  public static void init () {
    MPS4EmbargoAddMetadataTest.init();
    REQUEST_PARAMETER = MPS4EmbargoAddMetadataTest.getDefaultRequestParameters();
  }

  @Test
  public void performValidateExtractedData() {
    try {
      File input = new File("src/test/resources/net/pageseeder/ox/web/mps4/addmetadata/basic/embargo-add-metadata-test.xlsx");
      StepSimulator simulator = new StepSimulator(super.getModel().name(), input, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      Result result = super.performValidateExtractedData(simulator);
      Assert.assertEquals(ResultStatus.WARNING, result.status());
    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Override
  protected File getExpectedResultDirectory() {
    return null;
  }
}


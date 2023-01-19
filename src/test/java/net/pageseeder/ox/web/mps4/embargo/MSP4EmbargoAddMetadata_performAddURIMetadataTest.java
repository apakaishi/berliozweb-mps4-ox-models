package net.pageseeder.ox.web.mps4.embargo;

import net.pageseeder.app.simple.berlioz.GlobalSettingsUtils;
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
public class MSP4EmbargoAddMetadata_performAddURIMetadataTest extends MPS4EmbargoAddMetadataTest {
  private static Map<String, String> REQUEST_PARAMETER = null;

  @BeforeClass
  public static void init () {
    MPS4EmbargoAddMetadataTest.init();
    REQUEST_PARAMETER = MPS4EmbargoAddMetadataTest.getDefaultRequestParameters();
  }

  @Test
  public void performAddURIMetadata() {
    try {
      GlobalSettingsUtils.setup("local/appdata","mps4local");
      File input = new File("src/test/resources/net/pageseeder/ox/web/mps4/addmetadata/basic/embargo-add-metadata-test.xlsx");
      StepSimulator simulator = new StepSimulator(super.getModel().name(), input, REQUEST_PARAMETER);
      super.performExtractDataFromSpreadsheet(simulator);
      Result result = super.performAddURIMetadatas(simulator);
      Assert.assertEquals(ResultStatus.OK, result.status());
//      List<File> filesToIgnore = new ArrayList<>();
//      super.validateXML("data/result-add-metadatas.xml", simulator, filesToIgnore);

    } catch (Exception ex) {
      Assert.fail(ex.getMessage());
    }
  }

  @Override
  protected File getExpectedResultDirectory() {
    return null;
  }
}


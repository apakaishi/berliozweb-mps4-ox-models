/* Copyright (c) 2021 Allette Systems pty. ltd. */
package net.pageseeder.ox.web.mps4.mswSubmission;

import net.pageseeder.ox.web.mps4.MPS4OXTest;
import org.pageseeder.ox.OXConfig;
import org.pageseeder.ox.api.Result;
import org.pageseeder.ox.core.Model;
import org.pageseeder.ox.core.Pipeline;
import org.pageseeder.ox.step.StepSimulator;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author vku
 * @since 16 September 2021
 */
public abstract class MPS4SubmissionConversionTest extends MPS4OXTest {


  protected final static String MODEL_NAME = "msw-submission";
  protected final static String PIPELINE_NAME = "mps4-submission-conversion";


  private static Model MODEL = null;
  private static Pipeline PIPELINE = null;

  public static void init () {
    File modelDir = new File("local/appdata/model");
    OXConfig config = OXConfig.get();
    config.setModelsDirectory(modelDir);
    MODEL = new Model(MPS4SubmissionConversionTest.MODEL_NAME);
    MODEL.load();
    PIPELINE = MODEL.getPipeline(MPS4SubmissionConversionTest.PIPELINE_NAME);
  }

  protected static Map<String, String> getDefaultRequestParameters() {
    Map<String, String> requestParameter = new HashMap<>();
    return requestParameter;
  }

  protected Result performExtractDataFromSpreadsheet(StepSimulator simulator) {
    return performGeneric(simulator, "extract-data-from-spreadsheet");
  }

  protected Result performValidateExtractedData(StepSimulator simulator) {
    return performGeneric(simulator, "validate-extracted-data");
  }

  protected Result performCreateFilesProperties(StepSimulator simulator) {
    return performGeneric(simulator, "create-files-properties");
  }

  protected Result performZipFullPackage(StepSimulator simulator) {
    return performGeneric(simulator, "zip-full-package");
  }

  protected Model getModel() {
    return MODEL;
  }

  protected Pipeline getPipeline() {
    return PIPELINE;
  }
}

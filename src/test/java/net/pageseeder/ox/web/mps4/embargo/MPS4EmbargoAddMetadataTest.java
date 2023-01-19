/* Copyright (c) 2021 Allette Systems pty. ltd. */
package net.pageseeder.ox.web.mps4.embargo;

import net.pageseeder.ox.web.mps4.MPS4OXTest;
import org.pageseeder.ox.OXConfig;
import org.pageseeder.ox.api.Result;
import org.pageseeder.ox.core.Model;
import org.pageseeder.ox.core.Pipeline;
import org.pageseeder.ox.step.StepSimulator;
import org.pageseeder.ox.xml.utils.XMLComparator;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Carlos Cabral
 * @since 06 December 20222
 */
public abstract class MPS4EmbargoAddMetadataTest extends MPS4OXTest {


  protected final static String MODEL_NAME = "embargo";
  protected final static String PIPELINE_NAME = "embargo-add-metadata";


  private static Model MODEL = null;
  private static Pipeline PIPELINE = null;

  public static void init () {
    File modelDir = new File("local/appdata/model");
    OXConfig config = OXConfig.get();
    config.setModelsDirectory(modelDir);
    MODEL = new Model(MPS4EmbargoAddMetadataTest.MODEL_NAME);
    MODEL.load();
    PIPELINE = MODEL.getPipeline(MPS4EmbargoAddMetadataTest.PIPELINE_NAME);
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

  protected Result performAddURIMetadatas(StepSimulator simulator) {
    return performGeneric(simulator, "add-uri-metadatas");
  }

  protected Result performEditURI(StepSimulator simulator) {
    return performGeneric(simulator, "edit-uri");
  }

  protected Result performResultsLToCSV(StepSimulator simulator) {
    return performGeneric(simulator, "results-to-csv");
  }

  protected void compareActualExpected(File expectedResultBase, String folderOrFileName, StepSimulator simulator) {
    File actualResultBase = new File(simulator.getData().directory(), folderOrFileName);
    XMLComparator.compareXMLFile(expectedResultBase, actualResultBase);
  }

  protected Model getModel() {
    return MODEL;
  }

  protected Pipeline getPipeline() {
    return PIPELINE;
  }
}

/* Copyright (c) 2021 Allette Systems pty. ltd. */
package net.pageseeder.ox.web.mps4.apitest;

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
 * @author ccabral
 * @since 16 September 2021
 */
public abstract class CompareAPIWithXMLV3Test extends MPS4OXTest {


  protected final static String MODEL_NAME = "api-tests";
  protected final static String PIPELINE_NAME = "compare-api-with-xml-v3";


  private static Model MODEL = null;
  private static Pipeline PIPELINE = null;

  public static void init () {
    File modelDir = new File("local/appdata/model");
    OXConfig config = OXConfig.get();
    config.setModelsDirectory(modelDir);
    MODEL = new Model(CompareAPIWithXMLV3Test.MODEL_NAME);
    MODEL.load();
    PIPELINE = MODEL.getPipeline(CompareAPIWithXMLV3Test.PIPELINE_NAME);
  }

  protected static Map<String, String> getDefaultRequestParameters() {
    Map<String, String> requestParameter = new HashMap<>();
    return  requestParameter;
  }

  protected Result performunZipPBSXMLV3(StepSimulator simulator) {
    return performGeneric(simulator, "unzip-pbs-xml-v3");
  }

  protected Result performGetItemsTableFromPBSXMLV3(StepSimulator simulator) {
    return performGeneric(simulator, "get-items-table-from-pbs-xml-v3");
  }

  protected Result performGetItemsTableFromAPI(StepSimulator simulator) {
    return performGeneric(simulator, "get-items-table-from-api");
  }

  protected Result performZipItemsTables(StepSimulator simulator) {
    return performGeneric(simulator, "zip-items-tables");
  }

  protected Model getModel() {
    return MODEL;
  }

  protected Pipeline getPipeline() {
    return PIPELINE;
  }
}

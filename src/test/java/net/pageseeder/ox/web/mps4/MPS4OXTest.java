/* Copyright (c) 2021 Allette Systems pty. ltd. */
package net.pageseeder.ox.web.mps4;

import org.pageseeder.ox.api.Result;
import org.pageseeder.ox.core.Pipeline;
import org.pageseeder.ox.core.StepDefinition;
import org.pageseeder.ox.step.StepSimulator;
import org.pageseeder.ox.util.FileUtils;
import org.pageseeder.ox.xml.utils.FilesComparator;
import org.pageseeder.ox.xml.utils.IgnoreElementsDifferenceEvaluator;
import org.pageseeder.ox.xml.utils.XMLComparator;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * PBS OX Test
 *
 * @author ccabral
 * @since 21 May 2021
 */
public abstract class MPS4OXTest {

  protected Result performGeneric(StepSimulator simulator, String stepID) {
    StepDefinition stepDefinition = this.getPipeline().getStep(stepID);
    return simulator.process(stepDefinition.getStep(), null, null, stepDefinition.name(), stepDefinition.parameters());
  }

  protected void validateXML(String folderOrFileName, StepSimulator simulator, List<File> filesToIgnore) {
    File expectedResultBase = new File(this.getExpectedResultDirectory(), folderOrFileName);
    File resultBase = new File(simulator.getData().directory(), folderOrFileName);
    FilesComparator comparator = new FilesComparator(expectedResultBase, resultBase, filesToIgnore);
    comparator.compare();
  }

  protected void validateXMLIgnoringAttributes(String fileName, StepSimulator simulator, List<String> attributesToIgnore) throws IOException {
    File expectedResultBase = new File(this.getExpectedResultDirectory(), fileName);
    File resultBase = new File(simulator.getData().directory(), fileName);
    XMLComparator.isSimilar(FileUtils.read(expectedResultBase), FileUtils.read(resultBase), attributesToIgnore);
  }

  protected void validateXMLIgnoringElements(String fileName, StepSimulator simulator, List<String> elementsToIgnore) throws IOException {
    File expectedResultBase = new File(this.getExpectedResultDirectory(), fileName);
    File resultBase = new File(simulator.getData().directory(), fileName);
    XMLComparator.isSimilar(FileUtils.read(expectedResultBase), FileUtils.read(resultBase),
        new IgnoreElementsDifferenceEvaluator(elementsToIgnore));
  }

  protected abstract File getExpectedResultDirectory();

  protected abstract Pipeline getPipeline();
}

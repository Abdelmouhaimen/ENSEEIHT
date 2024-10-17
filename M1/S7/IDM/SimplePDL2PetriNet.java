package simplepdl.manip;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.sql.rowset.WebRowSet;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import simplepdl.Process;
import petrinet.*;
import simplepdl.*;

public class SimplePDL2PetriNet {

	public static void main(String[] args) {

         Map<String, Place> ready = new HashMap<String, Place>();
         Map<String, Place> started = new HashMap<String, Place>();
         Map<String, Place> running = new HashMap<String, Place>();
         Map<String, Place> finished = new HashMap<String, Place>();
         Map<String, Transition> start = new HashMap<String, Transition>();
         Map<String, Transition> finish = new HashMap<String, Transition>();

        PetrinetFactory myFactory = PetrinetFactory.eINSTANCE;
        PetriNet petrinet = myFactory.createPetriNet();
		
		// Charger le package SimplePDL afin de l'enregistrer dans le registre d'Eclipse.
		SimplepdlPackage packageInstance = SimplepdlPackage.eINSTANCE;
		
		// Enregistrer l'extension ".xmi" comme devant Ãªtre ouverte Ã 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());
		
		// CrÃ©er un objet resourceSetImpl qui contiendra une ressource EMF (le modÃ¨le de sortie)
		ResourceSet resSet = new ResourceSetImpl();

		// DÃ©finir la ressource (le modÃ¨le de sortie)
		URI modelURI = URI.createURI("rendu/JAVArendu.xmi");
		Resource resource = resSet.createResource(modelURI);

        // Charger le package PetriNet afin de l'enregistrer dans le registre d'Eclipse.
		PetrinetPackage packageInstance1 = PetrinetPackage.eINSTANCE;

        // CrÃ©er un objet resourceSetImpl qui contiendra une ressource EMF (le modÃ¨le d'entrée)
		ResourceSet resSetEntree = new ResourceSetImpl();

        // DÃ©finir la ressource (le modÃ¨le d'entrée)
		URI modelURIEntree = URI.createURI("developpement.xmi");
        Resource resourceEntree = resSetEntree.getResource(modelURIEntree,true);

        Process process = (Process) resourceEntree.getContents().get(0);
        
        petrinet.setName(process.getName());
        resource.getContents().add(petrinet);

        EList<ProcessElement> processElements = process.getProcessElements();

        for (int i=0 ; i < processElements.size();i++){
            ProcessElement processElement = processElements.get(i);

            if( processElement instanceof  WorkDefinition){

                Place placeReady = myFactory.createPlace();
                Place placeStarted = myFactory.createPlace();
                Place placeFinished = myFactory.createPlace();
                Place placeRunning= myFactory.createPlace();
                

                placeReady.setName(((WorkDefinition) processElement).getName() + "_ready");
                placeStarted.setName(((WorkDefinition) processElement).getName() + "_started");
                placeFinished.setName(((WorkDefinition) processElement).getName() + "_finished");
                placeRunning.setName(((WorkDefinition) processElement).getName() + "_running");

                placeReady.setJetons(1);
                placeStarted.setJetons(0);
                placeRunning.setJetons(0);
                placeFinished.setJetons(0);

                Transition transitionStart = myFactory.createTransition();
                Transition transitionFinish = myFactory.createTransition();

                transitionStart.setName(((WorkDefinition) processElement).getName() + "_start");
                transitionFinish.setName(((WorkDefinition) processElement).getName() + "_finish");

                Edge arcReadyStart = myFactory.createEdge();
                Edge arcStartStarted = myFactory.createEdge();	
                Edge arcStartRunning = myFactory.createEdge();
                Edge arcRunningFinish = myFactory.createEdge();
                Edge arcFinishFinished = myFactory.createEdge();

                arcReadyStart.setPoids(1);
                arcStartStarted.setPoids(1);
                arcFinishFinished.setPoids(1);
                arcRunningFinish.setPoids(1);
                arcStartRunning.setPoids(1);

                arcReadyStart.setEntree(placeReady);
                arcReadyStart.setSortie(transitionStart);
                arcStartRunning.setEntree(transitionStart);
                arcStartRunning.setSortie(placeRunning);
                arcStartStarted.setEntree(transitionStart);
                arcStartStarted.setSortie(placeStarted);
                arcRunningFinish.setEntree(placeRunning);
                arcRunningFinish.setSortie(transitionFinish);
                arcFinishFinished.setEntree(transitionFinish);
                arcFinishFinished.setSortie(placeFinished);

                arcFinishFinished.setType(arcType.NORMAL);
                arcReadyStart.setType(arcType.NORMAL);
                arcRunningFinish.setType(arcType.NORMAL);
                arcStartStarted.setType(arcType.NORMAL);
                arcRunningFinish.setType(arcType.NORMAL);

                petrinet.getPetrinetelement().add(placeReady);
                petrinet.getPetrinetelement().add(placeStarted);
                petrinet.getPetrinetelement().add(placeRunning);
                petrinet.getPetrinetelement().add(placeFinished);

                petrinet.getPetrinetelement().add(transitionStart);
                petrinet.getPetrinetelement().add(transitionFinish);

                petrinet.getPetrinetelement().add(arcReadyStart);
                petrinet.getPetrinetelement().add(arcRunningFinish);
                petrinet.getPetrinetelement().add(arcStartStarted);
                petrinet.getPetrinetelement().add(arcStartRunning);
                petrinet.getPetrinetelement().add(arcFinishFinished);

                ready.put(((WorkDefinition) processElement).getName(), placeReady);
                started.put(((WorkDefinition) processElement).getName(), placeStarted);
                running.put(((WorkDefinition) processElement).getName(), placeRunning);
                finished.put(((WorkDefinition) processElement).getName(), placeFinished);
                start.put(((WorkDefinition) processElement).getName(), transitionStart);
                finish.put(((WorkDefinition) processElement).getName(), transitionFinish);

            }else if (processElement instanceof  WorkSequence){

                Edge Work2Work = myFactory.createEdge();
                Work2Work.setType(arcType.READ_ARC);
                Work2Work.setPoids(1);
                WorkSequence wr = (WorkSequence)processElement;
                if(wr.getLinkType()==WorkSequenceType.START_TO_START){
                    Work2Work.setEntree(started.get(wr.getPredecessor().getName()));
                    Work2Work.setSortie(start.get(wr.getSuccessor().getName()));
                
                } else if (wr.getLinkType()==WorkSequenceType.START_TO_FINISH){
                    Work2Work.setEntree(started.get(wr.getPredecessor().getName()));
                    Work2Work.setSortie(finish.get(wr.getSuccessor().getName()));

                }else if (wr.getLinkType() == WorkSequenceType.FINISH_TO_START){
                    Work2Work.setEntree(finished.get(wr.getPredecessor().getName()));
                    Work2Work.setSortie(start.get(wr.getSuccessor().getName()));

                }else {
                	Work2Work.setEntree(finished.get(wr.getPredecessor().getName()));
                    Work2Work.setSortie(finish.get(wr.getSuccessor().getName()));
                }
                petrinet.getPetrinetelement().add(Work2Work);

            }else {
            	Ressource res = (Ressource) processElement;
            	Place placeRessource = myFactory.createPlace();
            	placeRessource.setName("Ressource_" + res.getName());
            	placeRessource.setJetons(res.getQuantite());
            	
            	petrinet.getPetrinetelement().add(placeRessource);
        		for (Amount d : res.getAmount()) {
        			// Ajout de l'arc entre la PlaceRessource et 
        			// la transition start correspondante
        			Edge arcDemande = myFactory.createEdge();
        			arcDemande.setEntree(placeRessource);
        			System.out.println(d.getWorkdefinition());
        			arcDemande.setSortie(start.get(d.getWorkdefinition().getName()));
        			arcDemande.setPoids(d.getNbOccurences());
        			petrinet.getPetrinetelement().add(arcDemande);
        			
        			// Ajout de l'arc entre la PlaceRessource et 
        			// la transition finish correspondante
        			Edge arcRetour = myFactory.createEdge();
        			arcRetour.setEntree(finish.get(d.getWorkdefinition().getName()));
        			arcRetour.setSortie(placeRessource);
        			arcRetour.setPoids(d.getNbOccurences());
        			petrinet.getPetrinetelement().add(arcRetour);
        		}
            	
            	
            }
            try {
            	resource.save(Collections.EMPTY_MAP);
            } catch (Exception e) {
    	    	e.printStackTrace();
    	    }
        }    
    }    
}

    









		
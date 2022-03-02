@IsTest
private class CodingChellengeTest {
    static testMethod void testCodingChellenge() {
        Test.startTest();
        CodingChallenge program = new CodingChallenge();
        
        program.connect(1, 2);
        program.connect(20, 3);
        program.connect(1, 8);
        program.connect(9, 8);
        program.connect(10, 8);

        program.connect(2, 6);
        program.connect(6, 9);
        program.connect(10, 12);

        Boolean isConnected = program.isConnected(2, 8);
        System.debug('Is Connected: ' + isConnected);
        System.assertEquals(true, isConnected);

        isConnected = program.isConnected(10, 9);
        System.debug('Is Connected: ' + isConnected);
        System.assertEquals(true, isConnected);

        isConnected = program.isConnected(1, 12);
        System.debug('Is Connected: ' + isConnected);
        System.assertEquals(true, isConnected);

        isConnected = program.isConnected(3, 12);
        System.debug('Is Connected: ' + isConnected);
        System.assertEquals(false, isConnected);

        isConnected = program.isConnected(1, 1);
        System.debug('Is Connected: ' + isConnected);
        System.assertEquals(false, isConnected);

        CodingChallenge programDFS = new CodingChallenge('DFS');

        programDFS.connect(1, 2);
        programDFS.connect(20, 3);
        programDFS.connect(1, 8);
        programDFS.connect(9, 8);
        programDFS.connect(10, 8);

        programDFS.connect(2, 6);
        programDFS.connect(6, 9);
        programDFS.connect(10, 12);

        programDFS.connect(88, 88);
        programDFS.connect(-1, 100);

        Boolean isConnectedDFS = programDFS.isConnected(2, 8);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(true, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(10, 9);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(true, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(1, 12);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(true, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(3, 12);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(false, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(77, 79);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(false, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(88, 88);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(false, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(-1, 100);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(false, isConnectedDFS);

        isConnectedDFS = programDFS.isConnected(1, 1);
        System.debug('Is ConnectedDFS: ' + isConnectedDFS);
        System.assertEquals(false, isConnectedDFS);

        Test.stopTest();
    }
}

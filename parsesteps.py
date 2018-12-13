
def parseSteps(fileName):
    with open(fileName) as file:
        steps = [line.rstrip('\n') for line in file]
    measures = [[]]
    measureNum = 0
    for line in steps:
        if ',' not in line:
            measures[measureNum].append(line)
        else:
            measures.append([])
            measureNum = measureNum + 1
    maxMeasureLength = 0
    for measure in measures:
        if len(measure) > maxMeasureLength:
            maxMeasureLength = len(measure)
    print("BPMMultiply:",maxMeasureLength/4)
    paddedMeasures = []
    for measure in measures:
        zeroPads = int((maxMeasureLength/len(measure))-1)
        newMeasure = []
        for beat in measure:
            newMeasure.append(beat)
            for i in range(zeroPads):
                newMeasure.append('0000')
        paddedMeasures.append(newMeasure)
    unpackedSteps = []
    for measure in paddedMeasures:
        for beat in measure:
            unpackedSteps.append(beat)
    finalSteps = []
    for beat in unpackedSteps:
        newBeat = []
        for char in beat:
            if char == '1' or char == '2':
                newBeat.append(1)
            else:
                newBeat.append(0)
        finalSteps.append(newBeat)
            
    return finalSteps

TheNightsBPM = 125.999992*4
TheNightsMusic = 'The Nights.ogg'
TheNightsSteps = parseSteps('TheNights.txt')
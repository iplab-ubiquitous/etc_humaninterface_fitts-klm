import controlP5.*;

//ウィンドウサイズ
final int windowSizeX = 340;
final int windowSizeY = 250;

ControlP5 cp5;

int count, missCount;
final int taskNum = 10;   // タスク回数
float startTime, elapsedTime, tmp;
float[] lapTime = new float[taskNum];
boolean running = false;

PFont font, labelFont;

int whichConvert;   // 0：摂氏->華氏, 1：華氏->摂氏
int taskTemperature;
String taskText = "ここにタスクが表示される";
Textlabel taskLabel;
RadioButton convertSwitcher;
Textfield inputTemperature, outputTemperature;
Button startButton, convertButton;


void settings(){
  size(windowSizeX,windowSizeY);
}

void setup(){
  font = createFont("osaka", 18, true);
  labelFont = createFont("osaka", 14, true);

  cp5 = new ControlP5(this);
  frameRate(100);

  fill(0);

  taskLabel = cp5.addTextlabel("task")
  .setPosition(60, 25)
  .setColor(color(0))
  .setFont(font)
  .setText(taskText);

  convertSwitcher = cp5.addRadioButton("switcher")
    .setPosition(60, 80)
    .setSize(30, 30)
    .setColorLabel(color(0))
    .setFont(font)
    .setLabelPadding(10, 0)
    .addItem("摂氏から華氏への変換", 0)
    .addItem("華氏から摂氏への変換", 1);
  convertSwitcher.getItem("摂氏から華氏への変換")
    .setFont(labelFont);
  convertSwitcher.getItem("華氏から摂氏への変換")
    .setFont(labelFont);

  inputTemperature = cp5.addTextfield("input")
    .setPosition(45, 170)
    .setSize(60, 30)
    .setFont(font)
    .setColorLabel(color(0))
    .setAutoClear(true)
    .keepFocus(true);
  inputTemperature.getCaptionLabel()
    .setFont(labelFont);

  outputTemperature = cp5.addTextfield("output")
    .setPosition(235, 170)
    .setSize(60, 30)
    .setFont(font)
    .setColorLabel(color(0))
    .setAutoClear(true);
  outputTemperature.getCaptionLabel()
    .setFont(labelFont);

  startButton = cp5.addButton("startExp")
    .setLabel("start")
    .setFont(labelFont)
    .setPosition(290, 0)
    .setSize(50, 30);

  convertButton = cp5.addButton("convert")
    .setPosition(135, 170)
    .setSize(70, 30)
    .setFont(labelFont);
}

void draw () {
  smooth();
  background(150, 0.5);
  if(running) {
    if(count == taskNum) {
      println("----------------------");
      println("total time: " + elapsedTime + " ms");
      println("miss: " + missCount + " time");
      println("lap time:");
      for (int i = 0; i < taskNum; i++) {
        println(lapTime[i]);
      }
      exit();
    }
  }
}

public void startExp() {
  startTime = millis();
  tmp = 0.0;
  count = 0;
  missCount = 0;
  inputTemperature.clear();
  running = true;
  nextTask();
}

public void convert() {
  if(running) {
    int input = 0;
    int switcher = (int)convertSwitcher.getValue();
    String text = inputTemperature.getText();
    if(!text.isEmpty()) {
      input = Integer.parseInt(text);
    }
    if(switcher == whichConvert && input == taskTemperature) {
      int output;
      if(whichConvert == 0) {
        // 摂氏->華氏
        output = (int)((float)input * 1.8 + 32.0);
      } else {
        // 華氏->摂氏
        output = (int)(((float)input - 32) / 1.8);
      }
      outputTemperature.setText(str(output));
      inputTemperature.clear();
      convertSwitcher.deactivateAll();

      tmp = elapsedTime;
      elapsedTime = millis() - startTime;
      lapTime[count] = elapsedTime - tmp;
      println("task " + (count+1) + ": " + lapTime[count] + " ms");
      count++;
      if(count < 10) nextTask();

    } else {
      taskLabel.setText(taskText + " X");
      println("miss");
      missCount++;
    }
  }
}

public void nextTask() {
  whichConvert = round(random(1));
  taskTemperature = round(random(100));
  if(whichConvert == 0) {
    taskText = "摂氏" + taskTemperature + "度を華氏に";
    taskLabel.setText(taskText);
  } else {
    taskText = "華氏" + taskTemperature + "度を摂氏に";
    taskLabel.setText(taskText);
  }
}

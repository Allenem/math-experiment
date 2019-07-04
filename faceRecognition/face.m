%选取文件夹，开始计时
DataSetName = 'Yale_32x32';tic;

%选取StTrainFile2作训练数据，该文件中每人有10张图片，其他文件引用则需改变X算法
train_data = dlmread(['.\txt格式数据\' DataSetName '\StTrainFile',num2str(2),'.txt']); %StTestFile2:150*1025,最后一列是类别
figure('NumberTitle', 'off', 'Name', '训练图集'); %给figure命名
X=cell(15,1); %训练数据X，创建15x1训练数组，每个人为1024x10的矩阵，将训练原矩阵分割
for i=10:10:150
    k=i/10;
    X{k}=[X{k},train_data(i-9:i,1:end-1)']; %第k个人的1024x10的矩阵训练数据
    A = train_data(i,1:end-1); %选每个人的最后一幅图片用作显示
    B_image = reshape(A,32,32); %将图片以32x32像素赋值给B_image
    subplot(3,5,k); %以3行5列显示图片
    imshow(B_image,[]); %将图片B_image显示
    title(['第' num2str(k) '人']);
end

%选取StTestFile3作测试数据，该文件中每人有1张图片，其他文件引用则需改变Y和准确率算法
test_data = dlmread(['.\txt格式数据\' DataSetName '\StTestFile',num2str(3),'.txt']); %StTestFile2:15*1025,最后一列是类别
figure('NumberTitle', 'off', 'Name', '测试图集');
Y=cell(15,1); %测试数据Y，创建15x1测试数组，每个人为1024x10的矩阵，将测试原矩阵分割
beta=cell(15,15); %最优解beta
y=cell(15,15); %预测值y
d=[]; %原始值向量与预测值向量之间距离
accuracy_num=0; %识别正确的数量
for j=1:15
    Y{j}=[Y{j},test_data(j,1:end-1)']; %第j个人的1024x10的矩阵测试数据
    for p=1:15 
        beta{j,p}=inv(X{p}'*X{p})*X{p}'*Y{j}; %计算每个训练数据下的对应第j个测试数据的最优解
        y{j,p}=X{p}*beta{j,p}; %计算预测值
        d(p)=dot(Y{j}-y{j,p},Y{j}-y{j,p}); %计算原始值向量与预测值向量之间距离
    end
    clear min;
    [m, n]=min(d); %m为d最小值，n为下标即第n份训练数据最接近第j份测试数据
    if n==j
        accuracy_num=accuracy_num+1; %计算正确数
    end
    C = test_data(j,1:end-1);
    D_image = reshape(C,32,32);
    subplot(3,5,j)
    imshow(D_image,[]) %显示每份测试数据图像
    title(['识别出是第' num2str(n) '人']); %显示识别结果，即所对应的训练数据中的哪个人
end
accuracy=accuracy_num/15;
time=toc; %计时结束
suptitle(['该算法对StTestFile3文件的人脸识别准确率为：',num2str(accuracy*100),'%' ,' 运算时间：',num2str(time),'s']); %显示识别准确率和运算时间

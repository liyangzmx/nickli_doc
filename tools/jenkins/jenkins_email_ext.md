pipeline{
	agent {
        label 'master'
	}
	stages {
        stage('Build'){
            steps {
                sh 'exit 1'
            }
        }
	}
	post {
        success {
            sh 'echo success'
            emailext(
                    to: "${params.mail_list}", 
                    subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', 
                    replyTo: 'liyang42@zuoyebang.com', 
                    mimeType: 'text/html', 
                    attachLog: true,
                    body: '''
                        <!DOCTYPE html>
                        <html>
                        <head>
                        <meta charset="UTF-8">
                        <title>${ENV, var="JOB_NAME"}-第${BUILD_NUMBER}次构建日志</title>
                        </head>

                        <body leftmargin="8" marginwidth="0" topmargin="8" marginheight="4" offset="0">
                            <table width="95%" cellpadding="0" cellspacing="0" style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">
                                <tr>
                                    <td>[本邮件由程序自动下发, 请勿回复! ]</td>
                                </tr>
                                <tr>
                                    <td>
                                        <h2><font color="#00FF00">构建结果 - ${BUILD_STATUS}</font></h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td><br />
                                        <b><font color="#0B610B">构建信息</font></b>
                                        <hr size="2" width="100%" align="center" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul>
                                            <li>项目名称：${PROJECT_NAME}</li>
                                            <li>构建编号：${BUILD_NUMBER}</li>                    
                                            <li>触发原因：${CAUSE}</li>   
                                            <li>构建日志：<a href="${BUILD_URL}console">${BUILD_URL}console</a></li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b><font color="#0B610B">变更信息:</font></b>
                                    <hr size="2" width="100%" align="center" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul>
                                            <li>上次构建成功后变化 :  ${CHANGES_SINCE_LAST_SUCCESS}</a></li>
                                        </ul>    
                                    </td>
                                </tr>
                        <tr>
                                    <td>
                                        <ul>
                                            <li>上次构建不稳定后变化 :  ${CHANGES_SINCE_LAST_UNSTABLE}</a></li>
                                        </ul>    
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul>
                                            <li>历史变更记录 : <a href="${PROJECT_URL}changes">${PROJECT_URL}changes</a></li>
                                        </ul>    
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <pre style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">$FAILED_TESTS</pre>
                                        <br />
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td>
                                        <b><font color="#0B610B">构建日志 (最后 100行):</font></b>
                                        <hr size="2" width="100%" align="center" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea cols="80" rows="30" readonly="readonly" style="font-family: Courier New">${BUILD_LOG, maxLines=100,escapeHtml=true}</textarea>
                                    </td>
                                </tr>
                                <hr size="2" width="100%" align="center" />
                        
                            </table>

                        </body>
                        </html>
                    '''
                )
        }
        failure {
            sh 'echo failure'
            emailext(
                to: "${params.mail_list}", 
                subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', 
                replyTo: 'liyang42@zuoyebang.com', 
                mimeType: 'text/html', 
                attachLog: true,
                body: '''
                    <!DOCTYPE html>
                    <html>
                    <head>
                    <meta charset="UTF-8">
                    <title>${ENV, var="JOB_NAME"}-第${BUILD_NUMBER}次构建日志</title>
                    </head>

                    <body leftmargin="8" marginwidth="0" topmargin="8" marginheight="4" offset="0">
                        <table width="95%" cellpadding="0" cellspacing="0" style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">
                            <tr>
                                <td>[本邮件由程序自动下发, 请勿回复! ]</td>
                            </tr>
                            <tr>
                                <td>
                                    <h2><font color="#FF0000">构建结果 - ${BUILD_STATUS}</font></h2>
                                </td>
                            </tr>
                            <tr>
                                <td><br />
                                    <b><font color="#0B610B">构建信息</font></b>
                                    <hr size="2" width="100%" align="center" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <ul>
                                        <li>项目名称：${PROJECT_NAME}</li>
                                        <li>构建编号：${BUILD_NUMBER}</li>                    
                                        <li>触发原因：${CAUSE}</li>   
                                        <li>构建日志：<a href="${BUILD_URL}console">${BUILD_URL}console</a></li>
                                    </ul>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b><font color="#0B610B">变更信息:</font></b>
                                <hr size="2" width="100%" align="center" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <ul>
                                        <li>上次构建成功后变化 :  ${CHANGES_SINCE_LAST_SUCCESS}</a></li>
                                    </ul>    
                                </td>
                            </tr>
                    <tr>
                                <td>
                                    <ul>
                                        <li>上次构建不稳定后变化 :  ${CHANGES_SINCE_LAST_UNSTABLE}</a></li>
                                    </ul>    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <ul>
                                        <li>历史变更记录 : <a href="${PROJECT_URL}changes">${PROJECT_URL}changes</a></li>
                                    </ul>    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <pre style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">$FAILED_TESTS</pre>
                                    <br />
                                </td>
                            </tr>
                            
                            <tr>
                                <td>
                                    <b><font color="#0B610B">构建日志 (最后 100行):</font></b>
                                    <hr size="2" width="100%" align="center" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea cols="80" rows="30" readonly="readonly" style="font-family: Courier New">${BUILD_LOG, maxLines=100,escapeHtml=true}</textarea>
                                </td>
                            </tr>
                            <hr size="2" width="100%" align="center" />
                    
                        </table>

                    </body>
                    </html>
                '''
            )
	    }
	    aborted{
            sh 'echo aborted'
        }
	}
}
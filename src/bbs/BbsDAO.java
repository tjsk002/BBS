package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;

	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 현재시간 가져옴
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			// 실행준비 단계로 만들어줌
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			// 실제 결과
			if (rs.next()) {
				return rs.getString(1);
				// 현재의 날짜 바로 발행
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터 베이스 오류 (빈문자열)
	}

	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		// 내림차순 마지막에 쓴 글을 가지고 올 수 있음
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
				// 그 다음 게시글 번호 때문에 n+1
			}
			return 1;
			// 첫번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류
	}
	
	

	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		// 내림차순 마지막에 쓴 글을 가지고 올 수 있음
		try {

			System.out.println("작성 내용:: " + bbsTitle + " " + userID + " " + bbsContent);

			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
		    pstmt.setInt(1, getNext()); // 다음에 쓸 게시글 번호
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);

			pstmt.executeUpdate();

			System.out.println("sql 작성");
			return 1;
//			return pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류
	}

	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		// 내림차순 마지막에 쓴 글을 가지고 올 수 있음 (10개까지)
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			/**
			 * getNext(): 33
			 * getNext() - (1-1)*10 = 33 
			 * getNext() - (2-1)*10 = 23 
			 * getNext() - (3-1)*10 = 13
			 */
			System.out.println("getNext():::" + (getNext() - (pageNumber - 1) * 10));
			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				Bbs bbs = new Bbs();

				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean nextPage(int pageNumber) {
		//(만약 10개만 있다면 끝, 그 이후는 페이지 넘김해줘야함)
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	//하나의 글 내용 불러오는 함수
	
	public Bbs getBbs(int bbsID) {
				String SQL = "SELECT * FROM BBS WHERE bbsID = ?";

				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);			
					 pstmt.setInt(1, bbsID);
					
					rs = pstmt.executeQuery();
					if (rs.next()) {
						Bbs bbs = new Bbs();

						bbs.setBbsID(rs.getInt(1));
						bbs.setBbsTitle(rs.getString(2));
						bbs.setUserID(rs.getString(3));
						bbs.setBbsDate(rs.getString(4));
						bbs.setBbsContent(rs.getString(5));
						bbs.setBbsAvailable(rs.getInt(6));
						return bbs;
						//결과를 bbs로 넣어서 반환함
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				return null;
	}

	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0 where bbsID = ?";
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
